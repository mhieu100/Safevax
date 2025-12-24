package com.dapp.backend.repository;

import com.dapp.backend.enums.TypeTransactionEnum;
import com.dapp.backend.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    @Query("SELECT p FROM Payment p WHERE p.referenceId = :appointmentId AND p.referenceType = :referenceType")
    Optional<Payment> findByAppointmentId(@Param("appointmentId") Long appointmentId,
            @Param("referenceType") TypeTransactionEnum referenceType);

    List<Payment> findByReferenceIdInAndReferenceType(List<Long> referenceIds, TypeTransactionEnum referenceType);

    Optional<Payment> findByReferenceIdAndReferenceType(Long referenceId, TypeTransactionEnum referenceType);
}
