module List
  class DataTableComponentPreview < ViewComponent::Preview
    def default
      render_with_template(locals: {
        data: data
      })
    end

    private

    def data
      [
        { product: "Emerald Silk Gown", price: "$875.00", sku: 124_689, qty: 140, sales: "$122,500.00" },
        { product: "Mauve Cashmere Scarf", price: "$230.00", sku: 124_533, qty: 83, sales: "$19,090.00" },
        { product: "Navy Merino Wool Blazer with khaki chinos and yellow belt", price: "$445.00", sku: 124_518, qty: 32, sales: "$14,240.00" },
      ]
    end
  end
end
