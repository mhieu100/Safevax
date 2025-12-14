package com.dapp.backend.service;

import com.dapp.backend.enums.TypeTransactionEnum;
import com.paypal.api.payments.*;
import com.paypal.base.rest.APIContext;
import com.paypal.base.rest.OAuthTokenCredential;
import com.paypal.base.rest.PayPalRESTException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PaypalService {

    @Value("${paypal.client.id}")
    private String clientId;

    @Value("${paypal.client.secret}")
    private String clientSecret;

    @Value("${paypal.mode}")
    private String mode;

    public static final double EXCHANGE_RATE_TO_USD = 0.000041;

    @Value("${paypal.cancel-url}")
    private String paypalCancelUrl;

    @Value("${paypal.success-url}")
    private String paypalSuccessUrl;

    public String createPaymentUrl(Double amount, Long referenceId, Long paymentId, TypeTransactionEnum type,
            String userAgent) throws PayPalRESTException {

        String platform = detectPlatform(userAgent);

        String cancelUrl = paypalCancelUrl + "?referenceId=" + referenceId + "&type=" + type + "&payment=" + paymentId
                + "&platform=" + platform;
        String successUrl = paypalSuccessUrl + "?referenceId=" + referenceId + "&type=" + type + "&payment=" + paymentId
                + "&platform=" + platform;

        Payment payment = createPayment(
                amount * EXCHANGE_RATE_TO_USD,
                "USD",
                "paypal",
                "sale",
                "Payment description",
                cancelUrl,
                successUrl);

        for (Links link : payment.getLinks()) {
            if (link.getRel().equals("approval_url")) {
                return link.getHref();
            }
        }
        return null;
    }

    private APIContext getApiContext() throws PayPalRESTException {
        Map<String, String> configMap = new HashMap<>();
        configMap.put("mode", mode);
        String accessToken = new OAuthTokenCredential(clientId, clientSecret, configMap).getAccessToken();
        APIContext context = new APIContext(accessToken);
        context.setConfigurationMap(configMap);
        return context;
    }

    private Payment createPayment(
            Double total,
            String currency,
            String method,
            String intent,
            String description,
            String cancelUrl,
            String successUrl) throws PayPalRESTException {

        Amount amount = new Amount();
        amount.setCurrency(currency);
        amount.setTotal(String.format("%.2f", total));

        Transaction transaction = new Transaction();
        transaction.setDescription(description);
        transaction.setAmount(amount);

        List<Transaction> transactions = new ArrayList<>();
        transactions.add(transaction);

        Payer payer = new Payer();
        payer.setPaymentMethod(method);

        Payment payment = new Payment();
        payment.setIntent(intent);
        payment.setPayer(payer);
        payment.setTransactions(transactions);

        RedirectUrls redirectUrls = new RedirectUrls();
        redirectUrls.setCancelUrl(cancelUrl);
        redirectUrls.setReturnUrl(successUrl);
        payment.setRedirectUrls(redirectUrls);

        return payment.create(getApiContext());
    }

    private String detectPlatform(String userAgent) {
        if (userAgent == null) {
            return "web";
        }
        userAgent = userAgent.toLowerCase();

        if (userAgent.contains("android") || userAgent.contains("okhttp") || userAgent.contains("retrofit")) {
            return "mobile";
        }
        if (userAgent.contains("ios") || userAgent.contains("cfnetwork") || userAgent.contains("darwin")) {
            return "mobile";
        }

        return "web";
    }
}
