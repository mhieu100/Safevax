package com.dapp.backend.service;

import com.dapp.backend.dto.request.CartItemRequest;
import com.dapp.backend.dto.response.CartItemResponse;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.model.Cart;
import com.dapp.backend.model.CartItem;
import com.dapp.backend.model.User;
import com.dapp.backend.model.Vaccine;
import com.dapp.backend.repository.CartRepository;
import com.dapp.backend.repository.VaccineRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository cartRepository;
    private final VaccineRepository vaccineRepository;
    private final AuthService authService;

    public List<CartItemResponse> getMyCart() throws AppException {
        User user = authService.getCurrentUserLogin();
        Cart cart = cartRepository.findByUser(user).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setUser(user);
            return cartRepository.save(newCart);
        });

        return cart.getCartItems().stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Transactional
    public void addToCart(CartItemRequest request) throws AppException {
        User user = authService.getCurrentUserLogin();
        Cart cart = cartRepository.findByUser(user).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setUser(user);
            return cartRepository.save(newCart);
        });

        Vaccine vaccine = vaccineRepository.findById(request.getVaccineId())
                .orElseThrow(() -> new AppException("Vaccine not found"));

        Optional<CartItem> existingItem = cart.getCartItems().stream()
                .filter(item -> item.getVaccine().getId() == vaccine.getId())
                .findFirst();

        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
        } else {
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setVaccine(vaccine);
            newItem.setQuantity(request.getQuantity());
            cart.getCartItems().add(newItem);
        }
        cartRepository.save(cart);
    }

    @Transactional
    public void updateCartItem(Long cartItemId, int quantity) throws AppException {
        User user = authService.getCurrentUserLogin();
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new AppException("Cart not found"));

        CartItem item = cart.getCartItems().stream()
                .filter(i -> i.getId().equals(cartItemId))
                .findFirst()
                .orElseThrow(() -> new AppException("Item not found in cart"));

        if (quantity <= 0) {
            cart.getCartItems().remove(item);
        } else {
            item.setQuantity(quantity);
        }
        cartRepository.save(cart);
    }

    @Transactional
    public void removeCartItem(Long cartItemId) throws AppException {
        User user = authService.getCurrentUserLogin();
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new AppException("Cart not found"));

        cart.getCartItems().removeIf(item -> item.getId().equals(cartItemId));
        cartRepository.save(cart);
    }

    @Transactional
    public void clearCart() throws AppException {
        User user = authService.getCurrentUserLogin();
        Optional<Cart> cart = cartRepository.findByUser(user);
        if (cart.isPresent()) {
            cart.get().getCartItems().clear();
            cartRepository.save(cart.get());
        }
    }

    private CartItemResponse toResponse(CartItem item) {
        return CartItemResponse.builder()
                .id(item.getId())
                .vaccineId(item.getVaccine().getId())
                .vaccineName(item.getVaccine().getName())
                .vaccineImage(item.getVaccine().getImage())
                .price(item.getVaccine().getPrice())
                .quantity(item.getQuantity())
                .build();
    }
}
