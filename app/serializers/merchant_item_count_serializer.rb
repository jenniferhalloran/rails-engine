class MerchantItemCountSerializer
    include JSONAPI::Serializer 
    attributes :name 

    attributes :count do |merchant|
        merchant.item_count
    end
end