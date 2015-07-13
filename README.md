# IletimerkeziSMS
	iletimerkezi.com API'lerini kullanarak toplu sms gönderme ve raporlama işlemlerini yapabilmek için hazarlanan Ruby Gem'idir.

## Setup

```
$ gem install 'iletimerkezisms'
```

## Usage Examples (Kullanım Örnekleri)

### Temel Bilgiler
iletimerkezi.com üzerinden toplu sms servisi kullanabilmeniz için verilen kullanıcı adı ve şifre bilgileri
- username: "username"
- password: "password"
- Desteklenen telefon numara formatları: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]

### SMS Gönderme
``` ruby
require 'iletimerkezisms'
=> Bir mesaj metnini birden fazla alıcıya göndermek için,

# SMS göndermek için kullanıcak argumanlar,
 
argv = {:sender=>"ILETI MRKZI", :message=>"Lorem ipsum ...", :numbers=>["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]}

request => Iletimerkezi.send(username, password, argv)

response => {"status"=>{"code"=>"200", "message"=>"İşlem başarılı"},"order"=>{"id"=>"order_id"}}

=> Birden fazla birbirinden farklı mesaj metnini birden fazla alıcıya göndermek için,

# SMS göndermek için kullanıcak argumanlar,

argv = {sender: "ILETI MRKZI",
                       messages: [
                         {text: "Deneme mesajı bir", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]},
                         {text: "Deneme mesajı iki", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx"]},
                         {text: "Deneme mesajı üç", numbers: ["905xxxxxxxxx"]}
                       ]
                     }
request => Iletimerkezi.multi_send(username, password, argv)

response => {"status"=>{"code"=>"200", "message"=>"İşlem başarılı"},"order"=>{"id"=>"order_id"}}

=> Yapılan sms isteğini iptal etmek için,

order_id: Sms gönderme işlemi sonrasında sunucu tarafından gelen cevaptan bulabilirsiniz.(order_id = response["order"]["id"])

request => Iletimerkezi.cancel(username, password, order_id)
response =>

```

### RAPORLAMA
``` ruby
require 'iletimerkezisms'

=> Gönderilen sms(ler) hakkında rapor elde edebilmek için kullanılır.
# SMS rapor oluşturabilmek için gönderileck argümanlar,

argv = {id: order_id page: 1, rowCount: 1000}

# NOT: 
# page: Rapor sayfasını ifade eder. İstek yapılırken gönderilmesi zorunlu değildir. Varsayılan değeri 1’dir.
# rowCount: Bir rapor sayfasındaki mesaj adedini belirtir. İstek yapılırken gönderilmesi zorunlu değildir. 
# Varsayılan değeri 1000’dir. Maksimum değeri #1000’dir. 
# Bir siparişte 1000’den fazla mesaj gönderilmişse ayrı bir istek ile diğer rapor sayfaları sorgulanmalıdır.

request => Iletimerkezi.report(username, password, argv)
response => {"status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
 							"order"=>
								  {"id"=>"7930802",
								   "status"=>"114",
								   "message"=>{"number"=>"+905545967632", "status"=>"111"}}
						}

=> Bakiye Bilgisi Sorgulama

# Hesabınızda kalan bakiye ve sms bilgisini elde etmenizi sağlar.

request => Iletimerkezi.balance(username, password)

response => {"status"=>{"code"=>"200", "message"=>"İşlem başarılı"}, "balance"=>{"amount"=>"0.0000", "sms"=>"4"}}

```
## API Dökünanı
Geliştirmeleri yaparken kullanılan [api dökümanı](https://docs.google.com/document/d/19mYfmnx_BAoO5tPjz2qrCE9LK9qNrafAVZTNqHmi1tQ/edit)
## Status Kodlarının Karşılıkları

Status Code  	| Status Message
------------- | -------------
110  | Mesaj gönderiliyor
111  | Mesaj gönderildi
112  | Mesaj gönderilemedi
113  | Siparişin gönderimi devam ediyor
114  | Siparişin gönderimi tamamlandı
115  | Sipariş gönderilemedi
200  | İşlem başarılı
400  | İstek çözümlenemedi
401  | Üyelik bilgileri hatalı
402  | Bakiye yetersiz
404  | API istek yapılan yönteme sahip değil
450  | Gönderilen başlık kullanıma uygun değil
451  | Tekrar eden sipariş
452  | Mesaj alıcıları hatalı
453  | Sipariş boyutu aşıldı
454  | Mesaj metni boş
455  | Sipariş bulunamadı
456  | Sipariş gönderim tarihi henüz gelmedi
457  | Mesaj gönderim tarihinin formatı hatalı
503  | Sunucu geçici olarak servis dışı