# Broi::Input

This library provides flexible API to deal with incoming ruby messages. It converts incoming hash onto predefined, structured object by passing it through predefined input validations.

Example:

```ruby
class PurchaseInput < Broi::Input
  attribute :product
  attribute :count, default: 1
  
  validate do
    required(:product).filled(:str?)
    optional(:count).maybe(:int?) 
  end
end
```

###Processing incoming hash

You instantiate the input by executing `call` method which, depending on the validation resutls, returns an instance of Broi::Input::Success/Failure.

```ruby
PurchaseInput.(product: 'Apple')
#=> #Success(<#PurchaseInput|soft product=#Value('Apple')>)


PurchaseInput.(product: 123)
#=> Failure({:product => ["must be string"])
```

### Soft input struct

Regardless of the validation result, you can always obtain soft input result by calling `input` on the result:

```ruby
PurchaseInput.(product: 'Apple').input
#=> <#PurchaseInput|soft product=#Value('Apple')>

PurchaseInput.(product: 123).input
#=> <#PurchaseInput|soft product=#InvalidValue(123)>
```

All the values accessible through the soft input are either `Broi::Input::Value`/`InvalidValue` and they respond to `valid?` and `invalid?` methods.

### Strict input

You can turn soft input into a strict input by calling `valid!`. Strict input is just typical Dry::Struct:

```ruby
PurchaseInput.(product: 'Apple').input.valid!
#=> <#PurchaseInput product='Apple'>

PurchaseInput.(product: 123).input.valid!
#! raises: Broi::Input::Invalid 
```

### Validation errors

Errors can be collected directly from the processing result.

```ruby
PurchaseInput.(product: 'Apple').errors
#=> {}

PurchaseInput.(product: 123).errors
#=> {:product => ["must be string"])
```


