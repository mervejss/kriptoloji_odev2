import 'package:flutter/material.dart';
import 'dart:math';
/*
SORU :

RSA  algoritmasını istediğiniz bir programlama dili kullanarak kodlayınız.

Program aşağıdaki özellikleri gerçekleştirmeli:

1. Öncelikle programda hesaplanan public ve private anahtarlar ekrana yazdırılmalıdır.

2. Programın ilk aşamasında şifreleme işlemi yapılmalıdır. Girdi olarak alınan açık mesaj (metin şeklinde) şifreli mesaj olarak ekrana yazdırmalıdır.

3. Programın ikinci aşamasında ise şifre çözme işlemi yapılmalıdır. Girdi olarak alınan şifreli mesaj açık mesaj haline getirilip ekrana yazdırılmalıdır.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Kodun çalışması:

Anahtar çiftini oluşturmak için "Anahtar Çiftini Oluştur" düğmesine basılır.
Açık bir mesaj yazılır.
"Şifrele" düğmesine basılarak mesaj şifrelenir ve şifreli mesaj gösterilir.
"Şifreyi Çöz" düğmesine basılarak şifreli mesaj çözülür ve açık mesaj gösterilir.
Bu şekilde, kullanıcı RSA algoritmasını kullanarak mesajları şifreleyebilir ve şifreleri çözebilir.
 */
void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Kriptoloji - RSA Algoritması',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: RSAHomePage(),
    );
  }
}

class RSAHomePage extends StatefulWidget
{
  @override
  _RSAHomePageState createState() => _RSAHomePageState();
}

class _RSAHomePageState extends State<RSAHomePage>
{
  TextEditingController plaintextController = TextEditingController();

  String publicKey = '';
  String privateKey = '';
  String plaintext = '';
  String encryptedMessage = '';
  String decryptedMessage = '';

  //generateKeyPair(): Bu işlev, rastgele bir anahtar çifti oluşturur. İki adet asal sayı seçer, bunları kullanarak bir n değeri hesaplar ve phi değerini hesaplar.
  //Ardından phi ile ilişkili olmayan bir e değeri ve modüler tersini hesaplayarak bir d değeri oluşturur.
  // Son olarak, oluşturulan anahtar çiftini publicKey ve privateKey değişkenlerine atar ve ekranda gösterir.
  void generateKeyPair()
  {
    var keyPair = _generateKeyPair();
    setState(() {
      publicKey = 'Public Key: e=${keyPair['publicKey']['e']}, n=${keyPair['publicKey']['n']}';
      privateKey = 'Private Key: d=${keyPair['privateKey']['d']}, n=${keyPair['privateKey']['n']}';
    });
  }

  //encryptMessage(): Bu işlev, kullanıcıdan alınan açık metni şifreler. plaintext ve publicKey değerlerini kullanarak metni şifreler ve sonucu encryptedMessage değişkenine atar.
  // Şifreli metni ekranda gösterir.
  void encryptMessage()
  {
    encryptedMessage = encrypt(plaintext, publicKey);
    setState(() {});
  }

  //decryptMessage(): Bu işlev, kullanıcıdan alınan şifreli metni çözer. encryptedMessage ve privateKey değerlerini kullanarak metni çözer ve sonucu decryptedMessage değişkenine atar.
  // Çözülmüş metni ekranda gösterir.
  void decryptMessage()
  {
    decryptedMessage = decrypt(encryptedMessage, privateKey);
    setState(() {});
  }

  //_generateKeyPair(): Bu işlev, anahtar çiftini oluşturmak için kullanılır.
  // Rastgele iki asal sayı seçer, n değerini hesaplar, phi değerini hesaplar, phi ile ilişkili olmayan bir e değeri seçer ve modüler tersini hesaplayarak bir d değeri oluşturur.
  // Oluşturulan anahtar çiftini bir harita şeklinde döndürür.
  Map<String, dynamic> _generateKeyPair()
  {
    var random = Random();

    var p = _generatePrimeNumber(random.nextInt(100) + 100);
    var q = _generatePrimeNumber(random.nextInt(100) + 100);

    var n = p * q;

    var phi = (p - 1) * (q - 1);

    var e = _generateRelativelyPrimeNumber(phi, random);

    var d = _calculateModularInverse(e, phi);

    var publicKey = {'e': e, 'n': n};
    var privateKey = {'d': d, 'n': n};

    return {'publicKey': publicKey, 'privateKey': privateKey};
  }

  //_generatePrimeNumber(): Bu işlev, verilen bir sayıdan büyük bir asal sayıyı döndürmek için kullanılır.
  // Verilen sayıdan başlayarak bir sonraki asal sayıyı bulana kadar artırır.
  int _generatePrimeNumber(int number)
  {
    var primeNumber = number;

    while (!_isPrime(primeNumber))
    {
      primeNumber++;
    }

    return primeNumber;
  }

  //_isPrime(): Bu işlev, bir sayının asal olup olmadığını kontrol eder.
  // Verilen sayının 2'den başlayarak kendisiyle ve sayının kareköküyle bölünüp bölünmediğini kontrol eder.
  bool _isPrime(int number)
  {
    if (number < 2) return false;

    for (var i = 2; i <= sqrt(number); i++)
    {
      if (number % i == 0) return false;
    }

    return true;
  }

  //_areRelativelyPrime(): Bu işlev, iki sayının birbirleriyle göreceli asal olup olmadığını kontrol eder.
  // İki sayının en küçük ortak böleni 1 ise, göreceli asaldırlar.
  bool _areRelativelyPrime(int a, int b)
  {
    for (var i = 2; i <= min(a, b); i++)
    {
      if (a % i == 0 && b % i == 0) return false;
    }

    return true;
  }

  //_generateRelativelyPrimeNumber(): Bu işlev, verilen bir phi değeri için göreceli asal olan bir e değeri oluşturur.
  int _generateRelativelyPrimeNumber(int phi, Random random)
  {
    var e = random.nextInt(phi - 2) + 2;

    while (!_areRelativelyPrime(e, phi))
    {
      e = random.nextInt(phi - 2) + 2;
    }

    return e;
  }

  //_modPow(): Bu işlev, üs alma işlemini modüler aritmetik ile gerçekleştirir.
  // Verilen base değerini exponent üssüne göre modulus ile hesaplar.
  int _modPow(int base, int exponent, int modulus)
  {
    var result = 1;

    while (exponent > 0)
    {
      if (exponent % 2 == 1)
      {
        result = (result * base) % modulus;
      }

      base = (base * base) % modulus;
      exponent ~/= 2;
    }
    return result;
  }

  //_calculateModularInverse(): Bu işlev, bir sayının modüler tersini hesaplar.
  // Verilen number ve modulus değerleri için modüler ters hesaplamasını gerçekleştirir.
  int _calculateModularInverse(int number, int modulus)
  {
    var t = 0;
    var newT = 1;
    var r = modulus;
    var newR = number;

    while (newR != 0)
    {
      var quotient = r ~/ newR;
      var tempT = t;
      t = newT;
      newT = tempT - quotient * newT;
      var tempR = r;
      r = newR;
      newR = tempR - quotient * newR;
    }

    if (r > 1)
    {
      throw Exception('Modüler ters bulunamadı.');
    }

    if (t < 0)
    {
      t = t + modulus;
    }

    return t;
  }

  //AŞAĞIDAKİ 2 FONKSİYON : RSA algoritmasının şifreleme ve şifre çözme işlemlerini gerçekleştiren iki fonksiyonu içermektedir: encrypt ve decrypt.

  //encrypt fonksiyonu, bir açık metni şifrelemek için kullanılır. Fonksiyon, plaintext (açık metin) ve publicKey (açık anahtar) parametrelerini alır.
  // publicKey parametresi virgülle ayrılmış bir dizedir ve e ve n değerlerini içerir.
  // Fonksiyon, açık metni karakter karakter dolaşarak her bir karakterin şifreli değerini hesaplar ve şifreli metni oluşturur.
  // Bu hesaplama için _modPow fonksiyonu kullanılır. Sonuç olarak, şifreli metin (ciphertext) döndürülür.
  String encrypt(String plaintext, String publicKey)
  {
    var parts = publicKey.split(',');
    var e = int.parse(parts[0].split('=')[1].trim());
    var n = int.parse(parts[1].split('=')[1].trim());

    var ciphertext = '';
    for (var i = 0; i < plaintext.length; i++)
    {
      var charCode = plaintext.codeUnitAt(i);
      var encryptedCharCode = _modPow(charCode, e, n);
      ciphertext += String.fromCharCode(encryptedCharCode);
    }

    return ciphertext;
  }


  //decrypt fonksiyonu ise bir şifreli metni çözmek için kullanılır. Fonksiyon, ciphertext (şifreli metin) ve privateKey (özel anahtar) parametrelerini alır.
  // privateKey parametresi virgülle ayrılmış bir dizedir ve d ve n değerlerini içerir. Fonksiyon, şifreli metni karakter karakter dolaşarak her bir karakterin çözülmüş değerini hesaplar ve açık metni oluşturur.
  // Bu hesaplama da _modPow fonksiyonu kullanılarak gerçekleştirilir. Sonuç olarak, çözülmüş metin (plaintext) döndürülür.
  String decrypt(String ciphertext, String privateKey)
  {
    var parts = privateKey.split(',');
    var d = int.parse(parts[0].split('=')[1].trim());
    var n = int.parse(parts[1].split('=')[1].trim());

    var plaintext = '';
    for (var i = 0; i < ciphertext.length; i++)
    {
      var charCode = ciphertext.codeUnitAt(i);
      var decryptedCharCode = _modPow(charCode, d, n);
      plaintext += String.fromCharCode(decryptedCharCode);
    }

    return plaintext;
  }

  //Her iki fonksiyon da, RSA algoritmasının temel matematiksel işlemlerini kullanarak şifreleme ve şifre çözme işlemlerini gerçekleştirir.
  // _modPow fonksiyonu, üs alma işlemini modüler aritmetik ile gerçekleştirir. Bu sayede büyük sayılar üzerinde işlem yapılabilir ve veri güvenliği sağlanır.
  // Fonksiyonlar, verilen açık veya şifreli metinleri karakterlerine ayırarak her bir karakterin ASCII kodunu hesaplar ve bu kodu şifreleme veya şifre çözme işlemini gerçekleştirmek için _modPow fonksiyonuna uygular.
  // Bu şekilde, metinlerin şifrelenmesi ve çözülmesi işlemleri gerçekleştirilir.

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],

      appBar: AppBar(
        title: Text('Kriptoloji - RSA Algoritması'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.all(13),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 4),
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurple[100],
          boxShadow:
          const [BoxShadow(
              color: Colors.black,
              spreadRadius: 10,
              blurRadius: 10)
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ANAHTARLAR",style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),

                Text(
                  'Public Key: $publicKey',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Private Key: $privateKey',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text("ŞİFRELENECEK MESAJ",style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 17),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.deepPurple[100],
                    boxShadow:
                    const [BoxShadow(
                        color: Colors.blueAccent,
                        spreadRadius: 10,
                        blurRadius: 10)
                    ],
                  ),
                  child: TextField(
                    controller: plaintextController, // Denetleyiciyi tanımla
                    decoration: InputDecoration(
                      labelText: 'Açık Mesaj',
                    ),
                    onChanged: (value) {
                      plaintext = value;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text("İŞLEMLER",style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple[100],
                    boxShadow:
                    const [BoxShadow(
                        color: Colors.blueAccent,
                        spreadRadius: 5,
                        blurRadius: 10)
                    ],
                  ),

                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.new_label_outlined),
                          onPressed: generateKeyPair,
                          label: Text('Anahtar Çiftini Oluştur'),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton.icon(
                          icon: Icon(Icons.enhanced_encryption),
                          onPressed: encryptMessage,
                          label: Text('ŞİFRELE         '),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Şifreli Mesaj => $encryptedMessage',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.no_encryption_gmailerrorred),
                          onPressed: decryptMessage,
                          label: Text('ŞİFREYİ ÇÖZ  '),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Açık Mesaj   =>  $decryptedMessage',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                  ),
                ),

                SizedBox(height: 25),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.clear),
                    onPressed: clearFields,
                    label: Text('TÜMÜNÜ TEMİZLE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void clearFields() {
    setState(() {
      publicKey = '';
      privateKey = '';
      plaintext = '';
      encryptedMessage = '';
      decryptedMessage = '';
      plaintextController.clear();

    });
  }
}
