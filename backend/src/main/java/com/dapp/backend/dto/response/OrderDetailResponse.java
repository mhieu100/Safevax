package com.dapp.backend.dto.response;

import com.dapp.backend.enums.OrderStatus;
import com.dapp.backend.enums.PaymentMethod;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class OrderDetailResponse {
    Long orderId;
    String orderDate;
    OrderStatus status;
    int itemCount;
    double total;
    String customerName;
    String customerEmail;
    String customerPhone;
    PaymentMethod paymentMethod;
    String paymentStatus;
    List<OrderItemResponse> items;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @FieldDefaults(level = AccessLevel.PRIVATE)
    public static class OrderItemResponse {
        Long vaccineId;
        String vaccineName;
        String vaccineImage;
        int quantity;
        double price;
        double subtotal;
    }
}
