
CafePOS.PosIndex =
  init: ->
    @_initGlobalVariables()
    @_initProductsData()
    @_handleSearchProducts()
    @_handleRemoveAllProduts()
    @_handleSubmitCheckOut()
  
  _initGlobalVariables: ->
    @total = 0.0
  
  _initProductsData: ->
    boss = @
    @fetchProducts('').then (data) =>
      for product in data
        boss.appendProducts(product)
      boss.handleAddToCartButton()

  _handleSearchProducts: ->
    boss = @
    $('#search-products').on 'keyup', (e) =>
      search_value = $(e.currentTarget).val()
      boss.fetchProducts(search_value).then (data) =>
        boss.clearProducts()
        for product in data
          boss.appendProducts(product)
        boss.handleAddToCartButton()
  
  _handleRemoveAllProduts: ->
    boss = @
    $(".btn-add-product").unbind()
    $(".btn-remove-product").unbind()
    $("#btn-remove-all-products").click (e) =>
      $("#order-summary-container").find("tr.product-item").remove()
      boss.calculateTotal()
  
  _handleSubmitCheckOut: ->
    boss = @
    check_out_data = []
    $("#btn-submit-checkout").click (e) =>
      e.preventDefault()
      customer_name = $("#customer-name-input").val()
      phone_number = $("#customer-phone-number-input").val()
      note = $("#customer-note-input").val()
      $("#order-summary-container tr.product-item").each (index, element) =>
        id = $(element).data("product-id")
        size_id = $(element).data("size-id")
        sugar_level = $(element).find("select.sugar-level-select").val()
        check_out_data.push({ product_id: id, size_id: size_id, sugar_level: sugar_level })
      $.ajax
        url: '/pos/check_out'
        type: 'POST'
        data: { 
          check_out: check_out_data,
          customer_name: customer_name,
          phone_number: phone_number,
          note: note
        }
        success: (data) =>
          $("#checkout-modal").modal("hide")
          $("#checkout-success-modal").modal("show")
          setTimeout(() =>
            $("#checkout-success-modal").modal("hide")
            window.location.href = "/pos"
          , 3000)
        error: (error) =>
          $("#checkout-error-modal").modal("show")

  fetchProducts: (search_value) ->
    new Promise (resolve, reject) ->
      $.ajax
        url: '/pos/search'
        type: 'GET'
        data: { search_value: search_value }
        success: (data) ->
          resolve(data)
        error: (error) ->
          reject(error)
  
  appendProducts: (product) ->
    size_html = "<br>"
    for size in product.sizes
      size_html += "<button id='#{product.id}-#{size.id}-#{Date.now()}' data-product='#{JSON.stringify(product)}' data-size='#{JSON.stringify(size)}' class='btn btn-outline-primary btn-sm btn-add-product m-r-5' type='button'>#{size.size}</button>"

    product_html = "
      <div class='col-sm-4 col-md-4 col-lg-3'>
        <div class='card overflow-hidden rounded-2'>
          <div class='position-relative'>
            <a href='javascript:void(0)'>
              <img alt='#{product.name}' class='card-img-top rounded-0' src='#{product.picture}'>
            </a>
            <a class='bg-primary rounded-circle p-2 text-white d-inline-flex position-absolute bottom-0 end-0 mb-n3 me-3' data-bs-placement='top' data-bs-title='Add To Cart' data-bs-toggle='tooltip' href='javascript:void(0)'>
              <i class='ti ti-basket fs-4'></i>
            </a>
          </div>
          <div class='card-body pt-3 p-4'>
            <h6 class='fw-semibold fs-4'>#{product.name}</h6>
            <div class='d-flex align-items-center justify-content-between'>
              <h6 class='fw-semibold fs-4 mb-0 text-muted'>#{product.category}</h6>
            </div>
            #{size_html}
          </div>
        </div>
      </div>
    "
    $('#products-container').append(product_html)

  clearProducts: ->
    $('#products-container').html ""
  
  handleAddToCartButton: ->
    boss = @
    $(".btn-add-product").unbind()
    $(".btn-add-product").click (e) =>
      id = $(e.currentTarget).attr("id")
      btn_product = $(e.currentTarget).data("product")
      btn_size = $(e.currentTarget).data("size")
      html_content = "
        <tr class='product-item' data-product-id='#{btn_product.id}' data-size-id='#{btn_size.id}' data-size-price='#{btn_size.price}'>
          <td>#{btn_product.name}</td>
          <td class='text-center'>
            <select name='sugar-level-#{id}' class='form-control sugar-level-select'>
              <option value='0'>0%</option>
              <option value='20'>20%</option>
              <option selected value='50'>50%</option>
              <option value='100'>100%</option>
          </td>
          <td class='text-center'>#{btn_size.size}</td>
          <td class='text-center product-price'>$ #{btn_size.price}</td>
          <td>
            <button class='btn btn-outline-danger btn-sm btn-remove-product'>
              <i class='ti ti-trash'></i>
            </button>
          </td>
        </tr>
      "
      $("#order-summary-container").prepend(html_content)
      boss.handleRemoveProductButton()
      boss.calculateTotal()
  
  handleRemoveProductButton: ->
    boss = @
    $(".btn-remove-product").unbind()
    $(".btn-remove-product").click (e) =>
      $(e.currentTarget).closest("tr").remove()
      boss.calculateTotal()

  calculateTotal: ->
    boss = @
    boss.total = 0
    total_drink = 0
    $("#order-summary-container tr.product-item").each (index, element) =>
      price = parseFloat($(element).data("size-price"))
      boss.total += price
      total_drink += 1
    $("#total-price").html("<strong>$ #{boss.total.toFixed(2)}</strong>")
    $("#summary-total-price").text("$ #{boss.total.toFixed(2)}")
    $("#checkout-total-drink").text("#{total_drink} Drinks")
    $("#checkout-total-price").text("$ #{boss.total.toFixed(2)}")
    if boss.total > 0
      $("#btn-checkout").prop("disabled", false)
    else
      $("#btn-checkout").prop("disabled", true)