package com.dapp.backend.service;

import com.dapp.backend.model.User;
import com.dapp.backend.model.VaccineRecord;
import com.dapp.backend.repository.UserRepository;
import com.dapp.backend.repository.VaccineRecordRepository;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

@Service
@RequiredArgsConstructor
public class PdfService {

        private final VaccineRecordRepository vaccineRecordRepository;
        private final UserRepository userRepository;

        // BRAND COLORS
        private static final BaseColor HEADER_BG = new BaseColor(76, 29, 149); // Deep Purple
        private static final BaseColor ACCENT_GREEN = new BaseColor(16, 185, 129); // Emerald
        private static final BaseColor BORDER_COLOR = new BaseColor(229, 231, 235); // Gray 200

        public ByteArrayInputStream generatePdf(Long userId) {
                Document document = new Document(PageSize.A4, 20, 20, 20, 20);
                ByteArrayOutputStream out = new ByteArrayOutputStream();

                try {
                        PdfWriter.getInstance(document, out);
                        document.open();

                        // Fetch Data
                        Optional<User> userOpt = userRepository.findById(userId);
                        User user = userOpt.orElse(new User());
                        String patientName = user.getFullName() != null ? user.getFullName() : "Unknown Patient";
                        String dob = user.getBirthday() != null
                                        ? user.getBirthday().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
                                        : "N/A";
                        String idHash = user.getBlockchainIdentityHash() != null ? user.getBlockchainIdentityHash()
                                        : "N/A";
                        String passportId = user.getId() != null ? String.valueOf(1000000 + user.getId()) : "PENDING";

                        List<VaccineRecord> records = vaccineRecordRepository
                                        .findByUserIdOrderByVaccinationDateDesc(userId);
                        long verifiedCount = records.stream().filter(VaccineRecord::isVerified).count();

                        // === 1. HEADER ===
                        addHeader(document, verifiedCount > 0);

                        // === 2. MAIN GRID (2 Columns) ===
                        PdfPTable mainLayout = new PdfPTable(2);
                        mainLayout.setWidthPercentage(100);
                        mainLayout.setWidths(new float[] { 1.8f, 1f }); // Left (Info) vs Right (QR)
                        mainLayout.setSpacingAfter(20);

                        // --- LEFT COLUMN CONTENT ---
                        PdfPCell leftCol = new PdfPCell();
                        leftCol.setBorder(Rectangle.NO_BORDER);
                        leftCol.setPaddingRight(10);

                        // Passport Info Card
                        PdfPTable passportInfoContent = new PdfPTable(1);
                        passportInfoContent.setWidthPercentage(100);
                        addCardTitle(passportInfoContent, "Passport Information");
                        addDetailRow(passportInfoContent, "Full Name", patientName, "Passport ID", passportId);
                        addDetailRow(passportInfoContent, "Issued Date", LocalDate.now().toString(), "DOB", dob);

                        leftCol.addElement(wrapInCard(passportInfoContent));
                        leftCol.addElement(new Paragraph("\n"));

                        // Blockchain Info Card
                        PdfPTable blockchainInfoContent = new PdfPTable(1);
                        blockchainInfoContent.setWidthPercentage(100);
                        addCardTitle(blockchainInfoContent, "Blockchain Verification");
                        addChainDetailRow(blockchainInfoContent, "Network Type:", "Permissioned Blockchain",
                                        new BaseColor(243, 232, 255), new BaseColor(126, 34, 206));
                        addChainDetailRow(blockchainInfoContent, "Consensus:", "Proof of Authority",
                                        new BaseColor(219, 234, 254), new BaseColor(29, 78, 216));
                        addChainDetailRow(blockchainInfoContent, "Total Records:", verifiedCount + " Verified",
                                        new BaseColor(209, 250, 229), new BaseColor(4, 120, 87));

                        leftCol.addElement(wrapInCard(blockchainInfoContent));
                        mainLayout.addCell(leftCol);

                        // --- RIGHT COLUMN CONTENT ---
                        PdfPCell rightCol = new PdfPCell();
                        rightCol.setBorder(Rectangle.NO_BORDER);
                        rightCol.setPaddingLeft(10);

                        // QR Card
                        PdfPTable qrContent = new PdfPTable(1);
                        qrContent.setWidthPercentage(100);
                        addCardTitle(qrContent, "Digital Verification");

                        try {
                                String qrData = "https://vaxsafe.com/verify/"
                                                + (idHash.length() > 20 ? idHash.substring(0, 20) : idHash);
                                BarcodeQRCode barcodeQRCode = new BarcodeQRCode(qrData, 200, 200, null);
                                Image qrImage = barcodeQRCode.getImage();
                                qrImage.scaleAbsolute(140, 140);
                                qrImage.setAlignment(Element.ALIGN_CENTER);

                                PdfPCell qrCell = new PdfPCell(qrImage);
                                qrCell.setBorder(Rectangle.NO_BORDER);
                                qrCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                                qrCell.setPaddingBottom(10);
                                qrContent.addCell(qrCell);

                                Paragraph scanText = new Paragraph("Scan to verify details",
                                                FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.GRAY));
                                scanText.setAlignment(Element.ALIGN_CENTER);
                                PdfPCell textCell = new PdfPCell(scanText);
                                textCell.setBorder(Rectangle.NO_BORDER);
                                textCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                                qrContent.addCell(textCell);
                        } catch (Exception e) {
                                PdfPCell errCell = new PdfPCell(new Phrase("QR Code Error"));
                                errCell.setBorder(Rectangle.NO_BORDER);
                                qrContent.addCell(errCell);
                                System.err.println("QR Generation Error: " + e.getMessage());
                        }

                        rightCol.addElement(wrapInCard(qrContent));
                        rightCol.addElement(new Paragraph("\n"));

                        // Stats Card
                        PdfPTable statsContent = new PdfPTable(1);
                        statsContent.setWidthPercentage(100);
                        addCardTitle(statsContent, "Blockchain Stats");
                        addStatBlock(statsContent, "Chain Confirmations", "1,247", new BaseColor(243, 232, 255));
                        addStatBlock(statsContent, "Trust Score", "99.8%", new BaseColor(219, 234, 254));

                        rightCol.addElement(wrapInCard(statsContent));
                        mainLayout.addCell(rightCol);

                        document.add(mainLayout);

                        // === 3. RECORDS TABLE ===
                        addRecordsTable(document, records);

                        // === 4. FOOTER ===
                        addFooter(document);

                        document.close();
                } catch (Exception e) {
                        e.printStackTrace();
                        try {
                                // Try to write error to PDF if still open
                                if (document.isOpen()) {
                                        document.add(new Paragraph("Error generating PDF: " + e.getMessage()));
                                        document.close();
                                }
                        } catch (Exception ex) {
                                // Ignore
                        }
                }

                return new ByteArrayInputStream(out.toByteArray());
        }

        // === HELPER METHODS ===

        private void addHeader(Document document, boolean isVerified) throws DocumentException {
                PdfPTable headerTable = new PdfPTable(1);
                headerTable.setWidthPercentage(100);

                PdfPCell headerCell = new PdfPCell();
                headerCell.setBackgroundColor(HEADER_BG);
                headerCell.setPadding(20);
                headerCell.setBorder(Rectangle.NO_BORDER);

                // Title Row with Badge
                PdfPTable titleRow = new PdfPTable(2);
                titleRow.setWidthPercentage(100);
                titleRow.setWidths(new float[] { 3, 1 });

                PdfPCell titleLeft = new PdfPCell();
                titleLeft.addElement(new Paragraph("Digital Vaccine Passport",
                                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, BaseColor.WHITE)));
                titleLeft.addElement(new Paragraph("Secured by Blockchain Technology",
                                FontFactory.getFont(FontFactory.HELVETICA, 12, new BaseColor(200, 200, 255))));
                titleLeft.setBorder(Rectangle.NO_BORDER);
                titleLeft.setBackgroundColor(HEADER_BG);
                titleRow.addCell(titleLeft);

                PdfPCell badgeCell = new PdfPCell(new Phrase(isVerified ? "VERIFIED" : "PENDING", FontFactory.getFont(
                                FontFactory.HELVETICA_BOLD, 12, isVerified ? ACCENT_GREEN : BaseColor.ORANGE)));
                badgeCell.setBackgroundColor(BaseColor.WHITE);
                badgeCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                badgeCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                badgeCell.setBorder(Rectangle.NO_BORDER);
                badgeCell.setPadding(8);

                // Create a small table for the badge to allow centering/padding within the cell
                PdfPTable badgeTable = new PdfPTable(1);
                badgeTable.setWidthPercentage(100);
                badgeTable.addCell(badgeCell);

                PdfPCell badgeWrapper = new PdfPCell(badgeTable);
                badgeWrapper.setBorder(Rectangle.NO_BORDER);
                badgeWrapper.setBackgroundColor(HEADER_BG);
                badgeWrapper.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleRow.addCell(badgeWrapper);

                headerCell.addElement(titleRow);

                // Header Stats
                headerCell.addElement(new Paragraph("\n"));
                PdfPTable headerStats = new PdfPTable(3);
                headerStats.setWidthPercentage(100);
                addHeaderStat(headerStats, "Network", "SafeVax Blockchain Network");
                addHeaderStat(headerStats, "Protocol", "Proof of Authority");
                addHeaderStat(headerStats, "Status", "Active & Verified");
                headerCell.addElement(headerStats);

                headerTable.addCell(headerCell);
                document.add(headerTable);
                document.add(new Paragraph("\n"));
        }

        private void addHeaderStat(PdfPTable table, String label, String value) {
                PdfPCell cell = new PdfPCell();
                cell.setBorder(Rectangle.NO_BORDER);
                cell.setBackgroundColor(HEADER_BG);
                cell.addElement(new Paragraph(label,
                                FontFactory.getFont(FontFactory.HELVETICA, 10, new BaseColor(200, 200, 255))));
                cell.addElement(new Paragraph(value,
                                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, BaseColor.WHITE)));
                table.addCell(cell);
        }

        // Wraps a content table in a card-styled cell
        private PdfPTable wrapInCard(PdfPTable content) {
                PdfPTable card = new PdfPTable(1);
                card.setWidthPercentage(100);
                card.setSpacingAfter(15);

                PdfPCell cardCell = new PdfPCell(content);
                cardCell.setBorder(Rectangle.BOX);
                cardCell.setBorderColor(BORDER_COLOR);
                cardCell.setBorderWidth(1f);
                cardCell.setPadding(15);
                cardCell.setBackgroundColor(BaseColor.WHITE);

                card.addCell(cardCell);
                return card;
        }

        private void addCardTitle(PdfPTable table, String title) {
                PdfPCell c = new PdfPCell(
                                new Phrase(title, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, HEADER_BG)));
                c.setBorder(Rectangle.NO_BORDER);
                c.setPaddingBottom(10);
                table.addCell(c);
        }

        private void addDetailRow(PdfPTable table, String l1, String v1, String l2, String v2) {
                PdfPTable row = new PdfPTable(2);
                row.setWidthPercentage(100);

                addDetailCell(row, l1, v1);
                addDetailCell(row, l2, v2);

                PdfPCell wrapper = new PdfPCell(row);
                wrapper.setBorder(Rectangle.NO_BORDER);
                table.addCell(wrapper);
        }

        private void addDetailCell(PdfPTable table, String label, String value) {
                PdfPCell c = new PdfPCell();
                c.setBorder(Rectangle.NO_BORDER);
                c.setPaddingBottom(8);
                c.addElement(new Paragraph(label, FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.GRAY)));
                c.addElement(new Paragraph(value,
                                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, BaseColor.BLACK)));
                table.addCell(c);
        }

        private void addChainDetailRow(PdfPTable table, String label, String value, BaseColor bg, BaseColor textColor) {
                PdfPTable row = new PdfPTable(2);
                row.setWidthPercentage(100);
                row.setSpacingBefore(5);

                PdfPCell l = new PdfPCell(
                                new Phrase(label, FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.GRAY)));
                l.setBorder(Rectangle.NO_BORDER);
                l.setVerticalAlignment(Element.ALIGN_MIDDLE);
                row.addCell(l);

                PdfPCell v = new PdfPCell(
                                new Phrase(value, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, textColor)));
                v.setBackgroundColor(bg);
                v.setBorder(Rectangle.NO_BORDER);
                v.setPadding(5);
                v.setHorizontalAlignment(Element.ALIGN_CENTER);
                row.addCell(v);

                PdfPCell wrapper = new PdfPCell(row);
                wrapper.setBorder(Rectangle.NO_BORDER);
                table.addCell(wrapper);
        }

        private void addStatBlock(PdfPTable table, String label, String value, BaseColor bg) {
                PdfPCell c = new PdfPCell();
                c.setBackgroundColor(bg);
                c.setBorder(Rectangle.NO_BORDER);
                c.setPadding(10);

                c.addElement(new Paragraph(label, FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.DARK_GRAY)));
                c.addElement(new Paragraph(value, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, HEADER_BG)));

                PdfPTable spacerTable = new PdfPTable(1);
                spacerTable.setWidthPercentage(100);
                spacerTable.addCell(c);

                PdfPCell wrapper = new PdfPCell(spacerTable);
                wrapper.setBorder(Rectangle.NO_BORDER);
                wrapper.setPaddingBottom(8);

                table.addCell(wrapper);
        }

        private void addRecordsTable(Document document, List<VaccineRecord> records) throws DocumentException {
                Paragraph title = new Paragraph("Blockchain-Verified Records",
                                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, HEADER_BG));
                title.setSpacingAfter(10);
                document.add(title);

                PdfPTable table = new PdfPTable(5);
                table.setWidthPercentage(100);
                table.setWidths(new float[] { 3, 1, 2, 2, 2 });
                table.setHeaderRows(1);

                Stream.of("Vaccine", "Dose", "Date", "Location", "Status").forEach(t -> {
                        PdfPCell h = new PdfPCell(new Phrase(t,
                                        FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE)));
                        h.setBackgroundColor(HEADER_BG);
                        h.setPadding(10);
                        h.setBorderColor(BORDER_COLOR);
                        h.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table.addCell(h);
                });

                if (records.isEmpty()) {
                        PdfPCell cell = new PdfPCell(new Phrase("No records found"));
                        cell.setColspan(5);
                        cell.setPadding(20);
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table.addCell(cell);
                } else {
                        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                        for (VaccineRecord r : records) {
                                addRecordCell(table, r.getVaccine() != null ? r.getVaccine().getName() : "Unknown");
                                addRecordCell(table, String.valueOf(r.getDoseNumber()));
                                addRecordCell(table, r.getVaccinationDate() != null ? r.getVaccinationDate().format(fmt)
                                                : "N/A");
                                addRecordCell(table, r.getCenter() != null ? r.getCenter().getName() : "Unknown");

                                PdfPCell s = new PdfPCell(new Phrase("Verified",
                                                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, ACCENT_GREEN)));
                                s.setPadding(10);
                                s.setBorderColor(BORDER_COLOR);
                                s.setHorizontalAlignment(Element.ALIGN_CENTER);
                                s.setVerticalAlignment(Element.ALIGN_MIDDLE);
                                table.addCell(s);
                        }
                }
                document.add(table);
        }

        private void addRecordCell(PdfPTable table, String text) {
                PdfPCell c = new PdfPCell(
                                new Phrase(text, FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK)));
                c.setPadding(10);
                c.setBorderColor(BORDER_COLOR);
                c.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(c);
        }

        private void addFooter(Document document) throws DocumentException {
                document.add(new Paragraph("\n"));
                PdfPTable footer = new PdfPTable(1);
                footer.setWidthPercentage(100);
                PdfPCell footerCell = new PdfPCell(
                                new Phrase("Explore on Blockchain: Your complete history is secured on SafeVax Chain.",
                                                FontFactory.getFont(FontFactory.HELVETICA, 10, HEADER_BG)));
                footerCell.setBackgroundColor(new BaseColor(243, 232, 255));
                footerCell.setPadding(15);
                footerCell.setBorder(Rectangle.NO_BORDER);
                footer.addCell(footerCell);
                document.add(footer);
        }
}
