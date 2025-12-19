package com.dapp.backend.dto.request;

import lombok.Data;

@Data
public class CartItemRequest {
    private Long vaccineId;
    private int quantity;
}
