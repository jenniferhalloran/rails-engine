class MerchantNameRevenueSerializer
    include JSONAPI::Serializer 
    attributes :name 

    attributes :revenue do |merchant|
        merchant.revenue 
    end
end