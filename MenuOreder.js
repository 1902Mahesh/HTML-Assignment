//Create Item Json

let currOrder = [];
let model;

let modelJson = $("#main-model-json").html();
model = JSON.parse(modelJson);
console.log(model);

function createOrderedItemJSON(itemId, itemName, itemAmount) {
  return {
    OrderItemId: 1,
    ItemId: Number(itemId),
    ItemName: itemName,
    Rate: Number(itemAmount),
    ItemInstruction: "",
    ReadQuantity: 0,
    AddOns: [],
    TotalAmount : 0,
  };
}

//Create ModifierJson
function createItemModifierJSON(mgId,modifierId, modifierName, rate) {
  return {
    ModifierGroupId: Number(mgId),
    ModifierItemId: Number(modifierId),
    Name: modifierName,
    Rate: Number(rate),
  };
}

let item = [];
let selectedModifierIds = [];
let orderItemIndex = 0;

$(document).ready(function () {
  GetItemList(0);

  $(".category-btn").click(function () {
    $(".category-btn").removeClass("active");
    $(this).addClass("active");
  });
});

function GetItemList(categoryId) {
  let search = $("#orderMenuSearch").val();
  $.ajax({
    url: '/OrderAppMenu/ItemList',
    type: "GET",
    data: { categoryId, search },
    success: function (data) {
      $("#itemListContent").html(data);
    },
    error: function () {
      $("#itemListContent").html("No Records Fetched");
    },
  });
}

$("#orderMenuSearch").on("input", function () {
  categoryId = $(".active").data("categoryid");
  GetItemList(categoryId);
});

function toggleFavoriteItem(id) {
  $.ajax({
    url: '/OrderAppMenu/ToggleFavoriteItem',
    type: "GET",
    data: { itemId: id },
    success: function (data) {
      categoryId = $(".active").data("categoryid");
      GetItemList(categoryId);
    },
    error: function () {
      categoryId = $(".active").data("categoryid");
      GetItemList(categoryId);
    },
  });
}

function loadMenuModifier(itemId, itemName, itemAmount) {
  $.ajax({
    url: '/OrderAppMenu/GetMenuModifier',
    type: "GET",
    data: { itemId: itemId, itemName: itemName },
    success: function (data) {
      $("#addModifierMenuModal").modal("show");
      $("#menuModifierContent").html(data);
      item = createOrderedItemJSON(itemId, itemName, itemAmount);
    },
    error: function () {
      $("#menuModifierContent").html("No records found");
    },
  });
}

let modifierList = [];
// function createOrderItemJson(itemId, itemName, itemAmount) {
//   return {
//     index: (orderItemIndex += 1),
//     ItemId: Number(itemId),
//     ItemName: itemName,
//     Rate: Number(itemAmount),
//     Quantity: 1,
//     AddOns: [],
//   };
// }

// function createOrderModifierJson(mgId, modifierId, modifierName, amount) {
//   return {
//     ModifierGroupId: Number(mgId),
//     Name: modifierName,
//     ModifierItemId: Number(modifierId),
//     Rate: Number(amount),
//   };
// }

$(document).on("click", ".modifierCard", function () {
  let $this = $(this);
  let mgId = $this.data("mgid");
  let modifierId = $this.data("modifierid");
  let modifierName = $this.data("modifiername");
  let amount = $this.data("amount");
  let maxAllowed = $this.data("maxallowed");
  let minAllowed = $this.data("minallowed");

  // Count already selected for this group
  let selectedInGroup = selectedModifierIds.filter(
    (e) => e.ModifierGroupId == mgId
  );

  let isAlreadySelected = selectedInGroup.some(
    (e) => e.ModifierId == modifierId
  );

  if (!isAlreadySelected) {
    if (selectedInGroup.length < maxAllowed) {
      modifierList.push(
        createItemModifierJSON(mgId, modifierId, modifierName, amount)
      );
      
      selectedModifierIds.push({
        ModifierGroupId: mgId,
        ModifierId: modifierId,
      });
      $this.addClass("selected_modifier");
    } else {
      toastr.warning(
        `You can select a maximum of ${maxAllowed} options for this group.`
      );
    }
  } else {
    if (selectedInGroup.length > minAllowed) {
      // Remove from selection
      selectedModifierIds = selectedModifierIds.filter(
        (id) => !(id.ModifierGroupId === mgId && id.ModifierId === modifierId)
      );
      modifierList = modifierList.filter(
        (mod) =>
          !(mod.ModifierGroupId === mgId && mod.ModifierItemId === modifierId)
      );
      $this.removeClass("selected_modifier");
    } else {
      toastr.warning(
        `You must select at least ${minAllowed} options for this group.`
      );
    }
  }
});

function appendOrderItems() {
  let allGroups = {};

  $(".modifierCard").each(function () {
    let mgId = $(this).data("mgid");
    let minAllowed = $(this).data("minallowed");

    if (!allGroups[mgId]) {
      allGroups[mgId] = {
        minAllowed: minAllowed,
        selectedCount: 0,
      };
    }
  });

  // Count selected items per group
  selectedModifierIds.forEach((mod) => {
    if (allGroups[mod.ModifierGroupId]) {
      allGroups[mod.ModifierGroupId].selectedCount++;
    }
  });

  // Validate each group

  let allGroupsValid = true;
  Object.keys(allGroups).forEach((mgId) => {
    let group = allGroups[mgId];
    if (group.selectedCount < group.minAllowed) {
      allGroupsValid = false;
    }
  });

  if (!allGroupsValid) {
    toastr.error(`You must select minimum option for modifier groups.`);
    return false;
  }

  item.AddOns = modifierList;

  //Added Extra
  currOrder.push(item);
  console.log(currOrder);

  OrderItem = JSON.stringify(item);

  $.ajax({
    url: '/OrderAppMenu/AppendOrderItems',
    type: "POST",
    data: { OrderItem },
    success: function (data) {
      $("#item-rows-container").append(data);
      calculateTotalWithTaxes();
      $("#addModifierMenuModal").modal("hide");
      modifierList = [];
      selectedModifierIds = [];
    },
    error: function () {
      $("#item-rows-container").html("No records found");
    },
  });
}

function getItemTotal(itemRow) {
  const itemAmount =
    parseFloat(itemRow.find(".item-amount").text().replace("₹", "")) || 0;
  const modifierAmount =
    parseFloat(itemRow.find(".modifier-amount").text().replace("₹", "")) || 0;
  return itemAmount + modifierAmount;
}

function calculateSubtotal() {
  let subtotal = 0;
  $("#item-rows-container .item-row").each(function () {
    subtotal += getItemTotal($(this));
  });
  return subtotal;
}

function calculateTotalWithTaxes() {
  const subtotal = calculateSubtotal();
  let totalTaxAmount = 0;

  $(".tax-row").each(function () {
    const $row = $(this);
    const taxRate = parseFloat($row.data("taxrate")) || 0;
    const isDefault =
      $row.data("isdefault") === false || $row.data("isdefault") === "false";
    const isPercentage =
      $row.data("taxtype") === true || $row.data("taxtype") === "true";
    const $checkbox = $row.find(".tax-checkbox");
    const taxId = $row.data("taxid");

    let applyTax = false;

    if (isDefault) {
      if ($checkbox.length && $checkbox.is(":checked")) {
        applyTax = true;
      }
    } else {
      applyTax = true;
    }

    let taxAmount = 0;
    if (applyTax) {
      taxAmount = isPercentage ? (subtotal * taxRate) / 100 : taxRate;
      totalTaxAmount += taxAmount;
    }

    $(`#tax-amount-${taxId}`).text(`₹${taxAmount.toFixed(2)}`);
  });

  const grandTotal = subtotal + totalTaxAmount;

  $("#subtotal-amount").text(`₹${subtotal.toFixed(2)}`);
  $("#grand-total-amount").text(`₹${grandTotal.toFixed(2)}`);
}

$(document).on("change", ".tax-checkbox", function () {
  calculateTotalWithTaxes();
});

function changeQuantity(element, action, step) {
  const itemRow = $(element).closest(".item-row");
  let quantity = Number($(element).parent().children("input").val());

  if (action === "inc") {
    quantity += step;
  } else if (action === "dec") {
    let minValue = $(element).parent().children("input").attr("min");
    console.log(minValue);
    if (quantity - 1 >= minValue) {
      quantity -= 1;
    }
  }

  $(element)
    .parent()
    .children("input")
    .val(quantity)
    .data("quantity", quantity);

  updateItemAmounts(itemRow, quantity);

  calculateTotalWithTaxes();
}

function updateItemAmounts(itemRow, quantity) {
  const itemAmount = itemRow.find(".item-amount");
  const modifierAmount = itemRow.find(".modifier-amount");

  const baseItemPrice = parseFloat(itemAmount.data("base")) || 0;
  const baseModifierPrice = parseFloat(modifierAmount.data("base")) || 0;

  const updatedItemPrice = baseItemPrice * quantity;
  const updatedModifierPrice = baseModifierPrice * quantity;

  itemAmount.text(`₹${updatedItemPrice.toFixed(2)}`);
  modifierAmount.text(`₹${updatedModifierPrice.toFixed(2)}`);
}

$(document).ready(function () {
  $(".item-row").each(function () {
    const row = $(this);
    const qtyDisplay = row.find(".quantity-box-display");
    const initialQty = parseInt(qtyDisplay.val()) || 1;
    qtyDisplay.data("quantity", initialQty);
  });
});

function deleteItem(tag) {
  const itemRow = $(tag).closest(".item-row");
  itemRow.remove();

  itemList = itemList.filter((item) => !item.index);
  calculateTotalWithTaxes();
}

function collectOrderDetails() {
  let orderItems = [];

  $(".item-row").each(function () {
    const $row = $(this);
    const itemId = parseInt($row.attr("id").replace("item-row-", ""));
    const orderItemId = $(this).data("orderitemid");
    const itemName = $row.find(".item-name-for-order").text().trim();
    const rate = parseFloat($row.find(".item-amount").text().replace("₹", ""));
    const quantity = parseInt($row.find(".quantity-box-display").val());
    const itemInstruction = $(
      `#order-item-${itemId} .orderItemInstruction>.itemInstruction`
    ).text();

    let addOns = [];
    $row.find(".modifier-list-for-order li").each(function () {
      const orderModifierId = $(this).find("div").data("ordermodifierid");
      const modifierItemId = $(this).find("div").data("modifierid");
      const name = $(this).find("span:first").text().trim();
      const rate = parseFloat(
        $(this).find("span:last").text().replace("₹", "")
      );
      addOns.push({ name, rate, modifierItemId, orderModifierId });
    });

    orderItems.push({
      orderItemId,
      itemId,
      itemName,
      rate,
      quantity,
      addOns,
      itemInstruction,
    });
  });

  let taxList = [];
  $(".tax-row").each(function () {
    const $row = $(this);
    const taxId = $row.data("taxid");
    const taxName = $row.find("#tax-name-" + taxId).text();
    const amount = parseFloat(
      $row
        .find("#tax-amount-" + taxId)
        .text()
        .replace("₹", "")
    );
    taxList.push({ taxName, amount });
  });

  const orderId = $("#orderIdHidden").val();
  const orderInstruction = $(".orderInstruction .instructionOrder").text();
  const customerId = $("#customerId").val();
  const subtotal = parseFloat($("#subtotal-amount").text().replace("₹", ""));
  const totalAmount = parseFloat(
    $("#grand-total-amount").text().replace("₹", "")
  );
  const paymentMethod = $(".paymentMethodCheckBox:checked").data("method");

  return {
    OrderId: orderId == null || orderId == "" ? 0 : orderId,
    CustomerId: customerId,
    TotalAmount: totalAmount,
    PaymentMethod: paymentMethod,
    OrderInstruction: orderInstruction,
    SubTotal: subtotal,
    items: orderItems,
    taxes: taxList,
  };
}

$(".saveOrderMenuBtn").on("click", function () {
  let order = collectOrderDetails();
  const jsonData = JSON.stringify(order);

  if (order.items.length == 0) {
    toastr.error("Add item to save order");
    return;
  }
  console.log(itemList, "itemList");

  /*
             $.ajax({
                url: "/OrderAppMenu/SaveOrder",
                method: "POST",
                contentType: "application/json",
                data: jsonData,
                success: function (response) {
                    if (response.success) {
                        toastr.success(response.message);
                        orderItemIndex = 0;
                    }
                    else {
                        toastr.error(response.errorMessage);
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error saving order:", error);
                }
            });

            */
});

$(".customerDetailBtn").on("click", function () {
  let customerId = $(this).data("customerid");
  $.ajax({
    url: "/OrderAppMenu/CustomerDetails",
    method: "GET",
    data: { customerId: customerId },
    success: function (response) {
      $("#customerDetailContent").html(response);
    },
    error: function (xhr, status, error) {
      $("#customerDetailContent").html("no data found");
    },
  });
});

function loadOrderComment() {
  $("#orderWiseCommentModal").modal("show");
  $.ajax({
    url: "/OrderAppMenu/OrderComment",
    method: "GET",
    success: function (response) {
      $("#orderWiseCommentContent").html(response);
      $(".orderInstructionInput").val(
        $(".orderInstruction .instructionOrder").text()
      );
    },
    error: function (xhr, status, error) {
      $("#orderWiseCommentContent").html("no data found");
    },
  });
}

function loadSpecialComment(itemId) {
  $("#specialCommentModal").modal("show");
  $.ajax({
    url: "/OrderAppMenu/ItemComment",
    method: "GET",
    data: { itemId },
    success: function (response) {
      $("#specialCommentContent").html(response);
      console.log(
        $(`#order-item-${itemId} .orderItemInstruction>.itemInstruction`).text()
      );
      $(".specialCommentInput").val(
        $(`#order-item-${itemId} .orderItemInstruction>.itemInstruction`).text()
      );
    },
    error: function (xhr, status, error) {
      $("#specialCommentContent").html("no data found");
    },
  });
}

$(document).on("click", ".saveOrderComment", function () {
  let orderInstruction = $(".orderInstructionInput").val();
  $(".orderInstruction").html(
    `<span class="clr_blue fw-bold" style="font-size:14px;">Order Instruction : </span><span class="instructionOrder" style="font-size:14px;">${orderInstruction}</span>`
  );
  $("#orderWiseCommentModal").modal("hide");
});

$(document).on("click", ".saveSpecialComment", function () {
  let ItemId = $(this).data("itemid");
  let orderItemInstruction = $(".specialCommentInput").val();
  $(`#order-item-${ItemId} .orderItemInstruction`).html(
    `<span class="clr_blue fw-bold" style="font-size:14px;">Instruction : </span><span class="itemInstruction" style="font-size:14px;">${orderItemInstruction}</span>`
  );
  $("#specialCommentModal").modal("hide");
});
