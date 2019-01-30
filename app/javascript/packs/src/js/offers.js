// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$( document ).ready(function() {
    $(".col_not_product").hide();
    $("radio_product").prop("checked", false);
    $(".radio_product").on("click", function() {
        var product = $(this).attr("id").replace(/offer_product_name_([^ ]*)/, "$1");
        var cards_not_product = $(".card_product").not("#card_product_" + product);
        cards_not_product.find("input:radio").prop("checked", false);
        cards_not_product.find(".col_not_product").hide();
        $("#card_product_" + product).find(".col_not_product").show();
    });
});
