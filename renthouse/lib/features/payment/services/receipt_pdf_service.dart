import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:renthouse/features/payment/domain/receipt.dart';
import 'package:renthouse/features/payment/domain/payment.dart';
import 'package:intl/intl.dart';

class ReceiptPdfService {
  static final _numberFormat = NumberFormat('#,###');
  static final _dateFormat = DateFormat('yyyy년 MM월 dd일');

  /// PDF 영수증 생성
  static Future<Uint8List> generateReceiptPdf(Receipt receipt) async {
    final pdf = pw.Document();

    // 한글 폰트 로드 (기본 폰트 사용)
    final font = await PdfGoogleFonts.nanumGothicRegular();
    final boldFont = await PdfGoogleFonts.nanumGothicBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 헤더
              _buildHeader(boldFont),
              pw.SizedBox(height: 30),
              
              // 영수증 정보
              _buildReceiptInfo(receipt, font, boldFont),
              pw.SizedBox(height: 20),
              
              // 수납 내역 테이블
              _buildItemsTable(receipt, font, boldFont),
              pw.SizedBox(height: 30),
              
              // 총액 및 결제 정보
              _buildPaymentSummary(receipt, font, boldFont),
              pw.SizedBox(height: 40),
              
              // 발행 정보
              _buildIssuerInfo(receipt, font),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// 헤더 섹션
  static pw.Widget _buildHeader(pw.Font boldFont) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            '영수증',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Container(
            width: 100,
            height: 2,
            color: PdfColors.black,
          ),
        ],
      ),
    );
  }

  /// 영수증 기본 정보
  static pw.Widget _buildReceiptInfo(Receipt receipt, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '영수증 번호: ${receipt.id.substring(0, 8).toUpperCase()}',
                style: pw.TextStyle(font: boldFont, fontSize: 12),
              ),
              pw.Text(
                '발행일: ${_dateFormat.format(receipt.issuedDate)}',
                style: pw.TextStyle(font: font, fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '임차인 정보',
                      style: pw.TextStyle(font: boldFont, fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '성명: ${receipt.tenantName}',
                      style: pw.TextStyle(font: font, fontSize: 10),
                    ),
                    pw.Text(
                      '연락처: ${receipt.tenantPhone}',
                      style: pw.TextStyle(font: font, fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '수납 정보',
                      style: pw.TextStyle(font: boldFont, fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '수납일: ${_dateFormat.format(receipt.paidDate)}',
                      style: pw.TextStyle(font: font, fontSize: 10),
                    ),
                    pw.Text(
                      '결제방법: ${_getPaymentMethodName(receipt.paymentMethod)}',
                      style: pw.TextStyle(font: font, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 수납 내역 테이블
  static pw.Widget _buildItemsTable(Receipt receipt, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '수납 내역',
          style: pw.TextStyle(font: boldFont, fontSize: 14),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(80),  // 월
            1: const pw.FixedColumnWidth(120), // 자산/호수
            2: const pw.FractionColumnWidth(0.4), // 항목
            3: const pw.FixedColumnWidth(80),  // 금액
          },
          children: [
            // 헤더
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('청구월', boldFont, 11, true),
                _buildTableCell('자산/호수', boldFont, 11, true),
                _buildTableCell('항목', boldFont, 11, true),
                _buildTableCell('금액', boldFont, 11, true),
              ],
            ),
            // 데이터 행들
            ...receipt.items.map((item) => pw.TableRow(
              children: [
                _buildTableCell(item.yearMonth, font, 10, false),
                _buildTableCell('${item.propertyName}\n${item.unitNumber}', font, 9, false),
                _buildTableCell(item.description, font, 10, false),
                _buildTableCell('${_numberFormat.format(item.amount)}원', font, 10, false, pw.TextAlign.right),
              ],
            )),
          ],
        ),
      ],
    );
  }

  /// 결제 요약 정보
  static pw.Widget _buildPaymentSummary(Receipt receipt, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '총 수납 금액',
                style: pw.TextStyle(font: boldFont, fontSize: 16),
              ),
              if (receipt.memo != null && receipt.memo!.isNotEmpty) ...[
                pw.SizedBox(height: 5),
                pw.Text(
                  '메모: ${receipt.memo}',
                  style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            ],
          ),
          pw.Text(
            '${_numberFormat.format(receipt.totalAmount)}원',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 20,
              color: PdfColors.blue800,
            ),
          ),
        ],
      ),
    );
  }

  /// 발행자 정보
  static pw.Widget _buildIssuerInfo(Receipt receipt, pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'RentHouse 부동산 관리 시스템',
            style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            '본 영수증은 전자적으로 생성되었습니다.',
            style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  /// 테이블 셀 생성
  static pw.Widget _buildTableCell(String text, pw.Font font, double fontSize, bool isHeader, [pw.TextAlign? align]) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align ?? pw.TextAlign.left,
      ),
    );
  }

  /// 결제 방법 이름 변환
  static String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return '현금';
      case PaymentMethod.transfer:
        return '계좌이체';
      case PaymentMethod.card:
        return '카드';
      case PaymentMethod.check:
        return '수표';
      case PaymentMethod.other:
        return '기타';
    }
  }

  /// PDF 파일 저장
  static Future<File> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  /// PDF 미리보기/인쇄 다이얼로그 표시
  static Future<void> showPrintPreview(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}