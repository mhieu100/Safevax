package com.dapp.backend.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CartItemResponse {
    private Long id; // CartItem ID
    private Long vaccineId;
    private String vaccineName;
    private String vaccineImage;
    private double price;
    private int quantity;
}
