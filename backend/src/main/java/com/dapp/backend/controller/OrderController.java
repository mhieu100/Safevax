package com.dapp.backend.controller;

import com.dapp.backend.annotation.ApiMessage;
import com.dapp.backend.dto.request.OrderRequest;
import com.dapp.backend.dto.request.UpdateOrderStatusRequest;
import com.dapp.backend.dto.response.OrderDetailResponse;
import com.dapp.backend.dto.response.OrderResponse;
import com.dapp.backend.dto.response.PaymentResponse;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.service.OrderService;
import com.paypal.base.rest.PayPalRESTException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {
    private final OrderService orderService;

    @PostMapping
    @ApiMessage("Create a new order")
    public ResponseEntity<PaymentResponse> create(@RequestBody OrderRequest request, HttpServletRequest httpRequest)
            throws AppException, PayPalRESTException {
        return ResponseEntity.ok(orderService.createOrder(request, httpRequest.getHeader("User-Agent")));
    }

    @GetMapping
    @ApiMessage("Get all orders of user")
    public ResponseEntity<List<OrderResponse>> getOrder() throws AppException {
        return ResponseEntity.ok(orderService.getOrder());
    }

    @GetMapping("/all")
    @ApiMessage("Get all orders (Admin)")
    public ResponseEntity<List<OrderResponse>> getAllOrders() {
        return ResponseEntity.ok(orderService.getAllOrders());
    }

    @GetMapping("/{orderId}")
    @ApiMessage("Get order detail for user")
    public ResponseEntity<OrderDetailResponse> getOrderDetail(@PathVariable Long orderId) throws AppException {
        return ResponseEntity.ok(orderService.getOrderByIdForUser(orderId));
    }

    @GetMapping("/admin/{orderId}")
    @ApiMessage("Get order detail (Admin)")
    public ResponseEntity<OrderDetailResponse> getOrderDetailAdmin(@PathVariable Long orderId) throws AppException {
        return ResponseEntity.ok(orderService.getOrderById(orderId));
    }

    @PutMapping("/admin/{orderId}/status")
    @ApiMessage("Update order status (Admin)")
    public ResponseEntity<OrderResponse> updateOrderStatus(
            @PathVariable Long orderId,
            @RequestBody UpdateOrderStatusRequest request) throws AppException {
        return ResponseEntity.ok(orderService.updateOrderStatus(orderId, request));
    }
}
