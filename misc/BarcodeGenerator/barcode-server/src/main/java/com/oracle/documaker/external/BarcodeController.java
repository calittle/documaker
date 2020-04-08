package com.oracle.documaker.external;

import com.oracle.documaker.external.generators.BarbecueBarcodeGenerator;
import com.oracle.documaker.external.generators.Barcode4jBarcodeGenerator;
import com.oracle.documaker.external.generators.QRGenBarcodeGenerator;
import com.oracle.documaker.external.generators.ZxingBarcodeGenerator;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.awt.image.BufferedImage;

@RestController
@RequestMapping("/barcodes")
public class BarcodeController {
	@GetMapping("")
	public String index(){
		return ("Missing required parameters. <a href='/help'>Help?</a>");
	}

	@GetMapping("/help")
	public String getHelp(){
		return ("Usage: <i>/barcodes</i>/{library}/{codetype}/{data}<br/>Where:<br/><ul><li><i>{library}</i> is one of: <ul><li>barbecue</li><li>barcode4j</li><li>qrgen</li><li>zxing</li></ul></li><li><i>{codetype}</i> is one of: <ul><li>upca</li><li>ean13</li><li>code128</li><li>pdf417</li><li>qrcode</li></ul></li><li><i>{data}</i> is either passed on querystring (GET) or as raw unencoded in POST.</li></ul><i>Note</i><ul><li>Not all libraries generate the same codetype in the same way. Use what works for you.</li><li>All libraries support all codetypes with the exception of <i>qrcode</i> which is only supported by <b>zxing</b> and <b>qrgen</b></li></ul>");
	}
    // //Barbecue library
    @GetMapping(value = "/barbecue/upca/{barcode}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barbecueUPCABarcode(@PathVariable("barcode") String barcode) throws Exception {
        return okResponse(BarbecueBarcodeGenerator.generateUPCABarcodeImage(barcode));
    }

    @GetMapping(value = "/barbecue/ean13/{barcode}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barbecueEAN13Barcode(@PathVariable("barcode") String barcode) throws Exception {
        return okResponse(BarbecueBarcodeGenerator.generateEAN13BarcodeImage(barcode));
    }

    @PostMapping(value = "/barbecue/code128", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barbecueCode128Barcode(@RequestBody String barcode) throws Exception {
        return okResponse(BarbecueBarcodeGenerator.generateCode128BarcodeImage(barcode));
    }

    @PostMapping(value = "/barbecue/pdf417", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barbecuePDF417Barcode(@RequestBody String barcode) throws Exception {
        return okResponse(BarbecueBarcodeGenerator.generatePDF417BarcodeImage(barcode));
    }

    // //Barcode4j library

    @GetMapping(value = "/barcode4j/upca/{barcode}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barcode4jUPCABarcode(@PathVariable("barcode") String barcode) {
        return okResponse(Barcode4jBarcodeGenerator.generateUPCABarcodeImage(barcode));
    }

    @GetMapping(value = "/barcode4j/ean13/{barcode}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barcode4jEAN13Barcode(@PathVariable("barcode") String barcode) {
        return okResponse(Barcode4jBarcodeGenerator.generateEAN13BarcodeImage(barcode));
    }

    @PostMapping(value = "/barcode4j/code128", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barcode4jCode128Barcode(@RequestBody String barcode) {
        return okResponse(Barcode4jBarcodeGenerator.generateCode128BarcodeImage(barcode));
    }

    @PostMapping(value = "/barcode4j/pdf417", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> barcode4jPDF417Barcode(@RequestBody String barcode) {
        return okResponse(Barcode4jBarcodeGenerator.generatePDF417BarcodeImage(barcode));
    }

    //Zxing library

    @GetMapping(value = "/zxing/upca/{barcode}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> zxingUPCABarcode(@PathVariable("barcode") String barcode) throws Exception {
        return okResponse(ZxingBarcodeGenerator.generateUPCABarcodeImage(barcode));
    }

    @GetMapping(value = "/zxing/ean13/{barcode}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> zxingEAN13Barcode(@PathVariable("barcode") String barcode) throws Exception {
        return okResponse(ZxingBarcodeGenerator.generateEAN13BarcodeImage(barcode));
    }

    @PostMapping(value = "/zxing/code128", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> zxingCode128Barcode(@RequestBody String barcode) throws Exception {
        return okResponse(ZxingBarcodeGenerator.generateCode128BarcodeImage(barcode));
    }

    @PostMapping(value = "/zxing/pdf417", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> zxingPDF417Barcode(@RequestBody String barcode) throws Exception {
        return okResponse(ZxingBarcodeGenerator.generatePDF417BarcodeImage(barcode));
    }

    @PostMapping(value = "/zxing/qrcode", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> zxingQRCode(@RequestBody String barcode) throws Exception {
        return okResponse(ZxingBarcodeGenerator.generateQRCodeImage(barcode));
    }

    //QRGen

    @PostMapping(value = "/qrgen/qrcode", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<BufferedImage> qrgenQRCode(@RequestBody String barcode) throws Exception {
        return okResponse(QRGenBarcodeGenerator.generateQRCodeImage(barcode));
    }

    private ResponseEntity<BufferedImage> okResponse(BufferedImage image) {
        return new ResponseEntity<>(image, HttpStatus.OK);
    }
}