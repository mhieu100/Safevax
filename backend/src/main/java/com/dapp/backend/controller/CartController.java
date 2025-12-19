package com.dapp.backend.controller;

import com.dapp.backend.annotation.ApiMessage;
import com.dapp.backend.dto.request.CartItemRequest;
import com.dapp.backend.dto.response.CartItemResponse;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping
    @ApiMessage("Get my cart")
    public ResponseEntity<List<CartItemResponse>> getMyCart() throws AppException {
        return ResponseEntity.ok(cartService.getMyCart());
    }

    @PostMapping
    @ApiMessage("Add to cart")
    public ResponseEntity<Void> addToCart(@RequestBody CartItemRequest request) throws AppException {
        cartService.addToCart(request);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    @ApiMessage("Update cart item quantity")
    public ResponseEntity<Void> updateCartItem(@PathVariable Long id, @RequestParam int quantity) throws AppException {
        cartService.updateCartItem(id, quantity);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Remove item from cart")
    public ResponseEntity<Void> removeCartItem(@PathVariable Long id) throws AppException {
        cartService.removeCartItem(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    @ApiMessage("Clear cart")
    public ResponseEntity<Void> clearCart() throws AppException {
        cartService.clearCart();
        return ResponseEntity.ok().build();
    }
}
