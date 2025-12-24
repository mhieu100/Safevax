package com.dapp.backend.service;

import com.dapp.backend.dto.request.OrderRequest;
import com.dapp.backend.dto.request.UpdateOrderStatusRequest;
import com.dapp.backend.dto.response.OrderDetailResponse;
import com.dapp.backend.dto.response.OrderResponse;
import com.dapp.backend.dto.response.PaymentResponse;
import com.dapp.backend.enums.OrderStatus;
import com.dapp.backend.enums.PaymentEnum;
import com.dapp.backend.enums.TypeTransactionEnum;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.model.*;
import com.dapp.backend.repository.OrderRepository;
import com.dapp.backend.repository.PaymentRepository;
import com.dapp.backend.repository.VaccineRepository;
import com.dapp.backend.util.DateTimeUtil;
import com.paypal.base.rest.PayPalRESTException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.dapp.backend.service.PaypalService.EXCHANGE_RATE_TO_USD;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final AuthService authService;
    private final OrderRepository orderRepository;
    private final VaccineRepository vaccineRepository;
    private final PaymentRepository paymentRepository;
    private final PaymentService paymentService;
    private final EmailService emailService;

    @org.springframework.transaction.annotation.Transactional(rollbackFor = Exception.class)
    public PaymentResponse createOrder(OrderRequest request, String userAgent)
            throws AppException, PayPalRESTException {
        User user = authService.getCurrentUserLogin();
        Order order = new Order();
        List<OrderItem> orderItems = new ArrayList<>();
        for (OrderRequest.ItemRequest item : request.getItems()) {
            Vaccine vaccine = vaccineRepository.findById(item.getId())
                    .orElseThrow(() -> new AppException("Vaccine not found"));

            if (vaccine.getStock() < item.getQuantity()) {
                throw new AppException("Not enough stock for vaccine: " + vaccine.getName());
            }
            vaccine.setStock(vaccine.getStock() - item.getQuantity());
            vaccineRepository.save(vaccine);

            OrderItem orderItem = new OrderItem();
            orderItem.setQuantity(item.getQuantity());
            orderItem.setVaccine(vaccine);
            orderItem.setOrder(order);
            orderItems.add(orderItem);
        }
        order.setUser(user);
        order.setOrderDate(LocalDateTime.now());
        order.setOrderItems(orderItems);
        order.setTotalAmount(request.getTotalAmount());
        order.setItemCount(request.getItemCount());
        order.setStatus(OrderStatus.PENDING);
        orderRepository.save(order);

        Payment payment = new Payment();
        payment.setReferenceId(order.getOrderId());
        payment.setReferenceType(TypeTransactionEnum.ORDER);
        payment.setAmount(request.getTotalAmount());
        payment.setMethod(request.getPaymentMethod());

        if (request.getPaymentMethod().toString().equals("PAYPAL")) {
            payment.setAmount(request.getTotalAmount() * EXCHANGE_RATE_TO_USD);
        } else if (request.getPaymentMethod().toString().equals("METAMASK")) {
            // Synchronize with AppointmentService: 1 ETH = 5,000,000 VND
            payment.setAmount(request.getTotalAmount() / 5000000.0);
        } else {
            payment.setAmount(request.getTotalAmount());
        }

        payment.setCurrency(request.getPaymentMethod().getCurrency());
        payment.setStatus(PaymentEnum.INITIATED);
        paymentRepository.save(payment);

        PaymentResponse response = new PaymentResponse();
        response.setReferenceId(order.getOrderId());
        response.setPaymentId(payment.getId());
        response.setMethod(payment.getMethod());

        switch (request.getPaymentMethod()) {
            case PAYPAL:
                String paypalUrl = paymentService.createPaypalUrl(request.getTotalAmount(), response.getReferenceId(),
                        response.getPaymentId(), TypeTransactionEnum.ORDER, userAgent);
                response.setPaymentURL(paypalUrl);
                break;
            case METAMASK:
                response.setAmount(request.getTotalAmount() / 5000000.0);
                break;
            case BANK:
                try {
                    String vnpayUrl = paymentService.createVnPayUrl((long) request.getTotalAmount(),
                            response.getReferenceId(),
                            response.getPaymentId(), TypeTransactionEnum.ORDER);
                    response.setPaymentURL(vnpayUrl);
                } catch (java.io.UnsupportedEncodingException e) {
                    throw new AppException("Error creating VNPAY URL");
                }
                break;
            case CASH:
                payment.setStatus(PaymentEnum.PROCESSING);
                paymentRepository.save(payment);
                order.setStatus(OrderStatus.PROCESSING);
                orderRepository.save(order);
                break;
            default:
                break;
        }

        return response;
    }

    public List<OrderResponse> getOrder() throws AppException {
        User user = authService.getCurrentUserLogin();
        return orderRepository.findAllByUser(user).stream().map(this::toResponse).toList();
    }

    public List<OrderResponse> getAllOrders() {
        return orderRepository.findAll().stream().map(this::toResponse).toList();
    }

    public OrderResponse toResponse(Order order) {
        OrderResponse response = new OrderResponse();
        response.setOrderId(order.getOrderId());
        response.setOrderDate(DateTimeUtil.format(order.getOrderDate(), DateTimeUtil.DATE_FORMAT));
        response.setItemCount(order.getItemCount());
        response.setTotal(order.getTotalAmount());
        response.setStatus(order.getStatus());
        if (order.getUser() != null) {
            response.setCustomerName(order.getUser().getFullName());
        }
        return response;
    }

    public OrderDetailResponse getOrderById(Long orderId) throws AppException {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new AppException("Order not found with ID: " + orderId));
        return toDetailResponse(order);
    }

    public OrderDetailResponse getOrderByIdForUser(Long orderId) throws AppException {
        User user = authService.getCurrentUserLogin();
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new AppException("Order not found with ID: " + orderId));
        
        if (!order.getUser().getId().equals(user.getId())) {
            throw new AppException("You don't have permission to view this order");
        }
        return toDetailResponse(order);
    }

    public OrderResponse updateOrderStatus(Long orderId, UpdateOrderStatusRequest request) throws AppException {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new AppException("Order not found with ID: " + orderId));
        
        OrderStatus oldStatus = order.getStatus();
        order.setStatus(request.getStatus());
        orderRepository.save(order);

        // Send email notification when status changes to DELIVERED
        if (request.getStatus() == OrderStatus.DELIVERED && oldStatus != OrderStatus.DELIVERED) {
            try {
                User customer = order.getUser();
                if (customer != null && customer.getEmail() != null) {
                    emailService.sendOrderStatusUpdate(
                            customer.getEmail(),
                            customer.getFullName(),
                            order.getOrderId(),
                            request.getStatus().name()
                    );
                }
            } catch (Exception e) {
                System.err.println("Failed to send order status email: " + e.getMessage());
            }
        }

        return toResponse(order);
    }

    private OrderDetailResponse toDetailResponse(Order order) {
        Payment payment = paymentRepository.findByReferenceIdAndReferenceType(
                order.getOrderId(), TypeTransactionEnum.ORDER).orElse(null);

        List<OrderDetailResponse.OrderItemResponse> itemResponses = order.getOrderItems().stream()
                .map(item -> OrderDetailResponse.OrderItemResponse.builder()
                        .vaccineId(item.getVaccine().getId())
                        .vaccineName(item.getVaccine().getName())
                        .vaccineImage(item.getVaccine().getImage())
                        .quantity(item.getQuantity())
                        .price(item.getVaccine().getPrice())
                        .subtotal(item.getQuantity() * item.getVaccine().getPrice())
                        .build())
                .collect(Collectors.toList());

        return OrderDetailResponse.builder()
                .orderId(order.getOrderId())
                .orderDate(DateTimeUtil.format(order.getOrderDate(), DateTimeUtil.DATE_FORMAT))
                .status(order.getStatus())
                .itemCount(order.getItemCount())
                .total(order.getTotalAmount())
                .customerName(order.getUser() != null ? order.getUser().getFullName() : null)
                .customerEmail(order.getUser() != null ? order.getUser().getEmail() : null)
                .customerPhone(order.getUser() != null ? order.getUser().getPhone() : null)
                .paymentMethod(payment != null ? payment.getMethod() : null)
                .paymentStatus(payment != null ? payment.getStatus().name() : null)
                .items(itemResponses)
                .build();
    }
}
