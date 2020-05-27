# AliexpressAPI

Aliexpress SDK for Ruby. 了解更多信息请访问 [Aliexpress API 文档](https://developers.aliexpress.com/en/doc.htm?docId=108970&docType=1).

## 安装
添加 `aliexpress-ruby-sdk` 到你的 Gemfile:
```ruby
gem 'aliexpress-ruby-sdk'
```
或通过gem安装 `gem install aliexpress-ruby-sdk`
```ruby
require 'aliexpress_api'
```

## Usage
### 1) 设置 App key 和 App secret
 在 Rails initializer 中创建文件：`config/initializers/omniauth.rb`， 并加入以下代码
```ruby
AliexpressAPI.configure do |config|
  config.app_key = "your App key"
  config.app_secret = "your App secret"

  # eg: config.service_endpoint = https://eco.taobao.com/router/rest
  config.service_endpoint = "SERVICE_ENDPOINT"
end
```
### 2) 向 Aliexpress 发送请求
调用 API 之前必须先激活 session：
```ruby
# 成功授权后拿到的 token
AliexpressAPI::Base.activate_session "token"
```
调用 API
```ruby
# 创建订单
AliexpressAPI::Order.create!(
    logistics_address: {
      address: "china"
    },
    product_items: {
      product_count: 1,
      product_id: "4000518642376",
      sku_attr: "N",
      logistics_service_name: "EMS"
    }
)

# 获取订单信息
AliexpressAPI::Order.find(300518642)

# 获取物流信息
AliexpressAPI::Logistic.tracking_info(
  logistics_no: "330211",
  out_ref: "300518642",
  service_name: "EMS",
  to_area: "US"
) 
```

### 3) API List
- [x] 功能实现 
- [ ] 功能未实现

#### -> Dropshipping
- [x] Dropshipping get product info
- [x] Dropshipping place order
- [x] Dropshipping obtain shipping info
- [x] Dropshipping get order info
- [x] Query simple information of product for dropshipper 
- [x] Dropshipping get tracking info
- [ ] Dropshipping sync sales data
#### -> other
- [ ] all
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
