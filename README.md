# IletimerkeziSMS

iletimerkezi.com API'lerini kullanarak toplu sms gönderme ve raporlama işlemlerini yapabilmek için hazarlanan Ruby Gem'idir.

[![Gem Version](https://badge.fury.io/rb/iletimerkezisms.svg)](http://badge.fury.io/rb/iletimerkezisms)

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
- sender: iletimerkezi.com yönetim panelinden tanımlamış ve iletimerkezi.com tarafından onaylanmış, maksimum 11 karakterden oluşan başlık bilgisidir. Gönderilen mesaj, alıcıya bu parametre ile belirtilen başlık ile yollanır. İstek yapılırken gönderilmesi zorunludur. URL encode işleminden geçirilmelidir

### İkinci yöntem
iletimerkezi.com üzerinden toplu sms servisi kullanabilmeniz için verilen public key ve secret key bilgileri
- kpublic: "IAMPUBLİC"
- ksecret: "IAMSECRET"
- Desteklenen telefon numara formatları: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]
- sender: iletimerkezi.com yönetim panelinden tanımlamış ve iletimerkezi.com tarafından onaylanmış, maksimum 11 karakterden oluşan başlık bilgisidir. Gönderilen mesaj, alıcıya bu parametre ile belirtilen başlık ile yollanır. İstek yapılırken gönderilmesi zorunludur. URL encode işleminden geçirilmelidir

## SMS Gönderme

### Bir mesaj metnini birden fazla alıcıya göndermek için,
``` ruby
require 'iletimerkezisms'

argv = {
        sender: "ILETI MRKZI",
        message: "Lorem ipsum ...",
        sendDateTime: "11/03/2016 15:00", #opsiyonel
        numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]
       }

# Note: sendDateTime argümanı opsiyoneldir. Zamanlanmış sms gönderimleri için kullanılır. 
#       Argüman olarak eklenilmeği sürece gönderim zamanı olarak o anki zaman otamatik olarak atanır.

IletimerkeziSMS.send(username, password, argv)

OR

sms = IletimerkeziSMS::SMS.new(username, password)
sms.send(argv)

response => {
              "status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
              "order"=>{"id"=>"order_id"}
            }

```
#### Veya key, secret ile işlem yapmak için
``` ruby
require 'iletimerkezisms'

argv = {
        api_gateway: true,
        sender: "ILETI MRKZI",
        message: "Lorem ipsum ...",
        sendDateTime: "11/03/2016 15:00", #opsiyonel
        numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]
       }


IletimerkeziSMS.send(username, password, argv)

response => {
              "status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
              "order"=>{"id"=>"order_id"}
            }
```

### Birden fazla birbirinden farklı mesaj metnini birden fazla alıcıya göndermek için,

``` ruby
require 'iletimerkezisms'

argv = {sender: "ILETI MRKZI",
        sendDateTime: "11/03/2016 15:00",#opsiyonel
        messages: [
            {text: "Deneme mesajı bir", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]},
            {text: "Deneme mesajı iki", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx"]},
            {text: "Deneme mesajı üç", numbers: ["905xxxxxxxxx"]}
          ]
        }
# Note:  sendDateTime argümanı opsiyoneldir. Zamanlanmış sms gönderimleri için kullanılır. 
#        Argüman olarak eklenilmeği sürece gönderim zamanı olarak o anki zaman otamatik olarak atanır.
                     
IletimerkeziSMS.multi_send(username, password, argv)

OR

sms = IletimerkeziSMS::SMS.new(username, password)
sms.multi_send(argv)

response => {
             "status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
             "order"=>{"id"=>"order_id"}
            }
```

#### Veya key, secret ile işlem yapmak için
``` ruby
require 'iletimerkezisms'

argv = {
        sender: "ILETI MRKZI",
        sendDateTime: "11/03/2016 15:00",#opsiyonel
        messages: [
            {text: "Deneme mesajı bir", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]},
            {text: "Deneme mesajı iki", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx"]},
            {text: "Deneme mesajı üç", numbers: ["905xxxxxxxxx"]}
          ]
       }


IletimerkeziSMS.multi_send(username, password, argv)

response => {
              "status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
              "order"=>{"id"=>"order_id"}
            }
```

### Yapılan SMS isteğini iptal etmek için,

- Not: order_id: Sms gönderme işlemi sonrasında sunucu tarafından gelen cevaptan bulabilirsiniz.(order_id = response["order"]["id"])

``` ruby
require 'iletimerkezisms'

IletimerkeziSMS.cancel(username, password, order_id)

# public ve secret ile yapmak için
# IletimerkeziSMS.cancel(public, secret, order_id, true)

OR

sms = IletimerkeziSMS::SMS.new(username, password)
sms.cancel(order_id)

```

## (REPORT) Raporlama İşlemleri

Gönderilen sms(ler) hakkında rapor elde edebilmek için kullanılır

#### Raporlama ile ilgili bilinmesi gerekenler;

- **page:** Rapor sayfasını ifade eder. İstek yapılırken gönderilmesi zorunlu değildir. Varsayılan değeri 1’dir. 
- **rowCount:** Bir rapor sayfasındaki mesaj adedini belirtir. İstek yapılırken gönderilmesi zorunlu değildir.Varsayılan değeri 1000’dir. Maksimum değeri #1000’dir. Bir siparişte 1000’den fazla mesaj gönderilmişse ayrı bir istek ile diğer rapor sayfaları sorgulanmalıdır.

``` ruby
require 'iletimerkezisms'

argv = {id: order_id, page: 1, rowCount: 1000}

IletimerkeziSMS.report(username, password, argv)

OR

report_object = IletimerkeziSMS::REPORT.new(username, password)
report_object.report(argv)

response => {
              "status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
              "order"=>
              {
               "id"=>"7930802",
               "status"=>"114",
               "message"=>{"number"=>"+905xxxxxxxxx", "status"=>"111"}
              }
            }
```

### Bakiye Bilgisi Sorgulama

- Hesabınızda kalan bakiye ve sms bilgisini elde etmenizi sağlar.

``` ruby
require 'iletimerkezisms'

IletimerkeziSMS.balance(username, password)

# public ve secret ile yapmak için
# IletimerkeziSMS.cancel(public, secret, true)

OR

report_object = IletimerkeziSMS::REPORT.new(username, password)
report_object.balance

response => {
              "status"=>{"code"=>"200", "message"=>"İşlem başarılı"},
              "balance"=>{"amount"=>"0.0000", "sms"=>"4"}
            }

```
## API Dökümanı
Geliştirmeleri yaparken kullanılan [API dökümanı](https://docs.google.com/document/d/19mYfmnx_BAoO5tPjz2qrCE9LK9qNrafAVZTNqHmi1tQ/edit)

## Status Kodlarının Karşılıkları

Status Code   | Status Message
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

### İletişim
İletişim ve öneriler için, irfansubas08@gmail.com
