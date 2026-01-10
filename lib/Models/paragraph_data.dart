class Paragraph {
  final String title;
  final String content;
  final String translation; // <-- YENİ: Türkçe Çeviri Alanı
  final String level;
  // Bu paragrafa özel kelime anlamları (Genel sözlüğü ezer)
  final Map<String, String>? specificMeanings;

  Paragraph({
    required this.title,
    required this.content,
    required this.translation, // <-- Constructor'a eklendi
    required this.level,
    this.specificMeanings,
  });
}

// --- GENİŞLETİLMİŞ, ÖZEL SÖZLÜKLÜ VE TAM ÇEVİRİLİ HİKAYE LİSTESİ ---
final List<Paragraph> storyList = [
  // ==========================================
  // A1 SEVİYESİ (Başlangıç)
  // ==========================================
  Paragraph(
      title: "My Morning Routine",
      level: "A1",
      translation:
          "Her sabah saat 7'de uyanırım. Güneş penceremden içeri parlar. Yüzümü soğuk suyla yıkarım. Bu beni uyandırır. Sonra dişlerimi fırçalarım. Kahvaltı yapmak için mutfağa giderim. Genellikle yumurta ve kızarmış ekmek yerim. Bir bardak portakal suyu içerim. Kahvaltıdan sonra kıyafetlerimi giyerim ve okula giderim.",
      content:
          "I wake up at 7 o'clock every morning. The sun shines through my window. I wash my face with cold water. It wakes me up. Then, I brush my teeth. I go to the kitchen to eat breakfast. I usually eat eggs and toast. I drink a glass of orange juice. After breakfast, I put on my clothes and go to school.",
      specificMeanings: {
        "wake": "Uyanmak",
        "shines": "Parlar",
        "through": "İçinden / Arasından",
        "window": "Pencere",
        "wash": "Yıkamak",
        "face": "Yüz",
        "brush": "Fırçalamak",
        "teeth": "Dişler",
        "kitchen": "Mutfak",
        "usually": "Genellikle",
        "toast": "Kızarmış ekmek",
        "glass": "Bardak",
        "clothes": "Kıyafetler",
      }),
  Paragraph(
      title: "The Little Dog",
      level: "A1",
      translation:
          "Tom'un küçük bir köpeği var. Adı Max. Max kahverengi ve beyazdır. Uzun kulakları ve kısa bir kuyruğu vardır. Max parkta oynamayı sever. Çok hızlı koşar. Tom bir top fırlattığında, Max onu geri getirir. Max çok mutlu ve arkadaş canlısı bir köpektir.",
      content:
          "Tom has a small dog. Its name is Max. Max is brown and white. He has long ears and a short tail. Max loves to play in the park. He runs very fast. When Tom throws a ball, Max brings it back. Max is a very happy and friendly dog.",
      specificMeanings: {
        "small": "Küçük",
        "brown": "Kahverengi",
        "ears": "Kulaklar",
        "short": "Kısa",
        "tail": "Kuyruk",
        "park": "Oyun parkı",
        "fast": "Hızlı",
        "throws": "Fırlatır",
        "ball": "Top",
        "brings": "Getirir",
        "back": "Geri",
        "friendly": "Arkadaş canlısı",
      }),
  Paragraph(
      title: "My Family House",
      level: "A1",
      translation:
          "Biz beyaz bir evde yaşıyoruz. Kırmızı bir çatısı var. Evde dört oda var. Benim odam küçük ama rahattır. Bir yatağım ve bir çalışma masam var. Bahçede iki büyük ağaç var. Babam ağaçların altında oturmayı sever. Annem çiçek yetiştirir. Evimizi seviyoruz.",
      content:
          "We live in a white house. It has a red roof. There are four rooms in the house. My room is small but cozy. I have a bed and a desk. In the garden, there are two big trees. My father likes to sit under the trees. My mother grows flowers. We love our house.",
      specificMeanings: {
        "white": "Beyaz",
        "red": "Kırmızı",
        "roof": "Çatı",
        "rooms": "Odalar",
        "cozy": "Rahat / Sıcak",
        "bed": "Yatak",
        "desk": "Çalışma masası",
        "garden": "Bahçe",
        "trees": "Ağaçlar",
        "sit": "Oturmak",
        "under": "Altında",
        "grows": "Yetiştirir",
        "flowers": "Çiçekler",
      }),
  Paragraph(
      title: "Going to the Market",
      level: "A1",
      translation:
          "Pazar günleri annemle pazara giderim. Pazar çok kalabalıktır. Çok insan vardır. Domates ve havuç gibi taze sebzeler alırız. Ayrıca elma ve muz gibi tatlı meyveler de alırız. Annem ekmek ve peynir de alır. Poşetleri taşımasına yardım ederim.",
      content:
          "On Sundays, I go to the market with my mother. The market is very crowded. There are many people. We buy fresh vegetables like tomatoes and carrots. We also buy sweet fruits like apples and bananas. My mother buys bread and cheese too. I help her carry the bags.",
      specificMeanings: {
        "sundays": "Pazar günleri",
        "market": "Pazar / Çarşı",
        "crowded": "Kalabalık",
        "fresh": "Taze",
        "vegetables": "Sebzeler",
        "tomatoes": "Domatesler",
        "carrots": "Havuçlar",
        "sweet": "Tatlı",
        "fruits": "Meyveler",
        "apples": "Elmalar",
        "bread": "Ekmek",
        "cheese": "Peynir",
        "carry": "Taşımak",
        "bags": "Poşetler / Çantalar",
      }),
  Paragraph(
      title: "A Rainy Afternoon",
      level: "A1",
      translation:
          "Dışarı bak! Yağmur yağıyor. Gökyüzü gri. Bugün futbol oynayamam. Odamda kalıyorum. Kitabımı alıp okuyorum. Kedim kanepede uyuyor. Evin içi sıcak. Yağmurun sesini seviyorum. Beni uykulu yapıyor.",
      content:
          "Look outside! It is raining. The sky is gray. I cannot play football today. I stay inside my room. I take my book and read. My cat sleeps on the sofa. It is warm inside the house. I like the sound of the rain. It makes me sleepy.",
      specificMeanings: {
        "outside": "Dışarı",
        "raining": "Yağmur yağıyor",
        "sky": "Gökyüzü",
        "gray": "Gri",
        "play": "Oynamak",
        "inside": "İçeri / İçinde",
        "sofa": "Kanepe",
        "warm": "Sıcak / Ilık",
        "sound": "Ses",
        "sleepy": "Uykulu",
      }),
  Paragraph(
      title: "My Best Friend",
      level: "A1",
      translation:
          "En iyi arkadaşım Sarah. O uzun boylu ve mavi gözlüdür. Aynı okula gidiyoruz. Sarah çok komiktir. Şakalar yapar ve beni güldürür. Ödevimizi birlikte yaparız. Hafta sonları film izleriz veya bisiklete bineriz. Onun gibi bir arkadaşım olduğu için mutluyum.",
      content:
          "My best friend is Sarah. She is tall and has blue eyes. We go to the same school. Sarah is very funny. She tells jokes and makes me laugh. We do our homework together. On weekends, we watch movies or ride our bikes. I am happy to have a friend like her.",
      specificMeanings: {
        "best": "En iyi",
        "tall": "Uzun boylu",
        "blue": "Mavi",
        "eyes": "Gözler",
        "same": "Aynı",
        "funny": "Komik",
        "tells": "Anlatır",
        "jokes": "Şakalar",
        "laugh": "Gülmek",
        "homework": "Ödev",
        "together": "Birlikte",
        "watch": "İzlemek",
        "ride": "Sürmek",
        "bikes": "Bisikletler",
      }),

  // ==========================================
  // A2 SEVİYESİ (Temel)
  // ==========================================
  Paragraph(
      title: "The Birthday Surprise",
      level: "A2",
      translation:
          "Dün kız kardeşimin doğum günüydü. On yaşına girdi. Ona sürpriz yapmak istedik. Annem kocaman bir çikolatalı pasta pişirdi. Babam renkli balonlar aldı. Kız kardeşim okuldan eve geldiğinde ışıkları kapattık. Kapıyı açtı ve hepimiz \"İyi ki doğdun!\" diye bağırdık. Çok şaşırdı ve mutlu oldu.",
      content:
          "Yesterday was my sister's birthday. She turned ten years old. We wanted to surprise her. My mom baked a huge chocolate cake. My dad bought colorful balloons. When my sister came home from school, we turned off the lights. She opened the door, and we all shouted, \"Happy Birthday!\" She was very surprised and happy.",
      specificMeanings: {
        "yesterday": "Dün",
        "turned": "Girdi (Yaşına)",
        "surprise": "Sürpriz",
        "baked": "Pişirdi (Fırında)",
        "huge": "Kocaman",
        "bought": "Satın aldı",
        "colorful": "Renkli",
        "balloons": "Balonlar",
        "turned off": "Kapattı",
        "lights": "Işıklar",
        "shouted": "Bağırdı",
        "surprised": "Şaşırmış",
      }),
  Paragraph(
      title: "A Trip to London",
      level: "A2",
      translation:
          "Geçen yaz ailemle Londra'yı ziyaret ettim. Çok büyük ve yoğun bir şehir. Big Ben'i ve London Eye'ı gördük. Kırmızı iki katlı bir otobüsle seyahat ettik. Hava biraz bulutluydu ama umursamadık. Bir restoranda balık ve patates kızartması yedik. Harika bir tatildi.",
      content:
          "Last summer, I visited London with my family. It is a very big and busy city. We saw the Big Ben and the London Eye. We travelled on a red double-decker bus. The weather was a bit cloudy, but we didn't mind. We ate fish and chips in a restaurant. It was a wonderful holiday.",
      specificMeanings: {
        "visited": "Ziyaret etti",
        "busy": "Yoğun / Kalabalık",
        "travelled": "Seyahat etti",
        "double-decker": "İki katlı",
        "weather": "Hava durumu",
        "cloudy": "Bulutlu",
        "mind": "Umursamak / Dert etmek",
        "chips": "Patates kızartması",
        "wonderful": "Harika",
      }),
  Paragraph(
      title: "Cooking Pasta",
      level: "A2",
      translation:
          "Makarna pişirmeyi seviyorum. Kolay ve lezzetli. Önce büyük bir tencerede su kaynatırım. Sonra makarnayı sıcak suya koyarım. On dakika beklerim. Beklerken sarımsak ve fesleğenli bir domates sosu yaparım. Son olarak makarnayı sosla karıştırıp biraz peynir eklerim. Tadı harika oluyor.",
      content:
          "I love cooking pasta. It is easy and delicious. First, I boil water in a large pot. Then, I put the pasta into the hot water. I wait for ten minutes. While waiting, I make a tomato sauce with garlic and basil. Finally, I mix the pasta with the sauce and add some cheese. It tastes amazing.",
      specificMeanings: {
        "cooking": "Pişirmek",
        "delicious": "Lezzetli",
        "boil": "Kaynatmak",
        "pot": "Tencere",
        "pour": "Dökmek",
        "wait": "Beklemek",
        "sauce": "Sos",
        "garlic": "Sarımsak",
        "basil": "Fesleğen",
        "mix": "Karıştırmak",
        "add": "Eklemek",
        "tastes": "Tadı olmak",
        "amazing": "Harika",
      }),
  Paragraph(
      title: "Lost in the Forest",
      level: "A2",
      translation:
          "İki arkadaş, Jack ve Leo, ormanda yürüyüşe çıktılar. Ağaçlar uzun ve yeşildi. Uzun süre yürüdüler. Aniden geri dönüş yolunu bilmediklerini fark ettiler. Kaybolmuşlardı. Jack korkmuştu ama Leo sakin kaldı. Yön bulmak için güneşe baktılar. Bir saat sonra yolu buldular. Çok rahatlamışlardı.",
      content:
          "Two friends, Jack and Leo, went for a walk in the forest. The trees were tall and green. They walked for a long time. Suddenly, they realized they didn't know the way back. They were lost. Jack was scared, but Leo stayed calm. They looked for the sun to find direction. After an hour, they found the road. They were very relieved.",
      specificMeanings: {
        "forest": "Orman",
        "walk": "Yürüyüş",
        "suddenly": "Aniden",
        "realized": "Fark etti",
        "lost": "Kayıp",
        "scared": "Korkmuş",
        "calm": "Sakin",
        "direction": "Yön",
        "road": "Yol",
        "relieved": "Rahatlamış",
      }),
  Paragraph(
      title: "The Library",
      level: "A2",
      translation:
          "Kütüphane şehirdeki en sevdiğim yerdir. Çok sessiz ve huzurludur. Raflarda binlerce kitap vardır. Tarih, bilim veya macera hakkında kitaplar bulabilirsiniz. Her Cumartesi ders çalışmak için oraya giderim. Kütüphaneci hoş bir hanımefendi. İlginç kitaplar bulmama yardım ediyor.",
      content:
          "The library is my favorite place in the city. It is very quiet and peaceful. There are thousands of books on the shelves. You can find books about history, science, or adventure. I go there every Saturday to study. The librarian is a nice lady. She helps me find interesting books.",
      specificMeanings: {
        "library": "Kütüphane",
        "favorite": "Favori / En sevilen",
        "quiet": "Sessiz",
        "peaceful": "Huzurlu",
        "shelves": "Raflar",
        "history": "Tarih",
        "science": "Bilim",
        "adventure": "Macera",
        "librarian": "Kütüphaneci",
        "lady": "Hanımefendi",
        "interesting": "İlginç",
      }),
  Paragraph(
      title: "Winter Sports",
      level: "A2",
      translation:
          "Kışın birçok insan dağlara gider. Kayak yapmayı veya snowboard yapmayı severler. Hava soğuktur, bu yüzden ceket, eldiven ve şapka gibi sıcak giysiler giyerler. Kar beyaz ve güzeldir. Kayak yaptıktan sonra insanlar bir kafede sıcak çikolata içerler. Kışı geçirmek için eğlenceli bir yoldur.",
      content:
          "In winter, many people go to the mountains. They like to ski or snowboard. It is cold, so they wear warm clothes like jackets, gloves, and hats. The snow is white and beautiful. After skiing, people drink hot chocolate in a cafe. It is a fun way to spend the winter.",
      specificMeanings: {
        "winter": "Kış",
        "mountains": "Dağlar",
        "ski": "Kayak yapmak",
        "snowboard": "Kar kayağı",
        "wear": "Giymek",
        "jackets": "Ceketler",
        "gloves": "Eldivenler",
        "hats": "Şapkalar",
        "snow": "Kar",
        "spend": "Geçirmek (Vakit)",
      }),

  // ==========================================
  // B1 SEVİYESİ (Orta)
  // ==========================================
  Paragraph(
      title: "The Mysterious Letter",
      level: "B1",
      translation:
          "Bir sabah, Bay Smith posta kutusunda tuhaf bir mektup buldu. Zarfın üzerinde isim yoktu. Merakla açtı. İçinde bir harita ve bir anahtar vardı. Harita eski parktaki bir konumu gösteriyordu. Bay Smith haritayı takip etmeye karar verdi. Parka yürüdü ve bir ağacın altında küçük ahşap bir kutu buldu. Anahtar kutuyu açtı. İçinde çocukluğuna ait bir fotoğraf buldu. Onu kimin gönderdiği bir gizemdi.",
      content:
          "One morning, Mr. Smith found a strange letter in his mailbox. There was no name on the envelope. He opened it curiously. Inside, there was a map and a key. The map showed a location in the old park. Mr. Smith decided to follow the map. He walked to the park and found a small wooden box under a tree. The key opened the box. Inside, he found a photo of his childhood. It was a mystery who sent it.",
      specificMeanings: {
        "strange": "Tuhaf",
        "mailbox": "Posta kutusu",
        "envelope": "Zarf",
        "curiously": "Merakla",
        "map": "Harita",
        "key": "Anahtar",
        "location": "Konum",
        "decided": "Karar verdi",
        "follow": "Takip etmek",
        "wooden": "Ahşap",
        "box": "Kutu",
        "childhood": "Çocukluk",
        "mystery": "Gizem",
      }),
  Paragraph(
      title: "Healthy Habits",
      level: "B1",
      translation:
          "Sağlıklı bir yaşam sürmek disiplin gerektirir. Meyve ve sebze yemek vücudunuz için vitamin sağlar. Yeterince su içmek sizi susuz bırakmaz ve enerjik tutar. Egzersiz de çok önemlidir; 30 dakikalık bir yürüyüş bile kalp sağlığınızı iyileştirebilir. Fiziksel sağlığın yanı sıra zihinsel sağlık da önemlidir. Yeterince uyumak ve stresi azaltmak beyninizin daha iyi çalışmasına yardımcı olur.",
      content:
          "Living a healthy life requires discipline. Eating fruits and vegetables provides vitamins for your body. Drinking enough water keeps you hydrated and energetic. Exercise is also crucial; even a 30-minute walk can improve your heart health. Besides physical health, mental health is important too. Getting enough sleep and reducing stress helps your brain function better.",
      specificMeanings: {
        "requires": "Gerektirir",
        "discipline": "Disiplin",
        "provides": "Sağlar",
        "hydrated": "Su ihtiyacı karşılanmış",
        "energetic": "Enerjik",
        "crucial": "Hayati / Çok önemli",
        "improve": "Geliştirmek",
        "mental": "Zihinsel",
        "reducing": "Azaltmak",
        "stress": "Stres",
        "function": "İşlev görmek",
      }),
  Paragraph(
      title: "The History of Coffee",
      level: "B1",
      translation:
          "Kahve dünyadaki en popüler içeceklerden biridir. Efsaneye göre Etiyopya'daki bir keçi çobanı tarafından keşfedilmiştir. Keçilerinin belli bir ağaçtan kırmızı meyveler yedikten sonra çok enerjik olduklarını fark etti. Meyveleri kendisi de denedi ve aynı enerjiyi hissetti. Bugün kahve Brezilya ve Kolombiya gibi birçok ülkede yetiştirilmektedir. İnsanlar uyanmak veya arkadaşlarıyla sosyalleşmek için içerler.",
      content:
          "Coffee is one of the most popular drinks in the world. Legend says it was discovered by a goat herder in Ethiopia. He noticed that his goats became very energetic after eating red berries from a certain tree. He tried the berries himself and felt the same energy. Today, coffee is grown in many countries like Brazil and Colombia. People drink it to wake up or socialize with friends.",
      specificMeanings: {
        "popular": "Popüler",
        "legend": "Efsane",
        "discovered": "Keşfedildi",
        "herder": "Çoban",
        "noticed": "Fark etti",
        "berries": "Meyveler (Böğürtlen türü)",
        "certain": "Belirli",
        "tried": "Denedi",
        "grown": "Yetiştirilir",
        "socialize": "Sosyalleşmek",
      }),
  Paragraph(
      title: "A Job Interview",
      level: "B1",
      translation:
          "Maria iş görüşmesi konusunda gergindi. Büyük bir teknoloji şirketinde çalışmak istiyordu. En iyi takım elbisesini giydi ve erken geldi. Görüşmeci ona yetenekleri ve önceki tecrübeleri hakkında sorular sordu. Maria kendinden emin bir şekilde cevap verdi. Projelerinden ve kodlama tutkusundan bahsetti. Görüşmenin sonunda müdür gülümsedi ve elini sıktı. Bir hafta sonra işi aldı.",
      content:
          "Maria was nervous about her job interview. She wanted to work at a big technology company. She wore her best suit and arrived early. The interviewer asked her about her skills and previous experience. Maria answered confidently. She talked about her projects and her passion for coding. At the end of the interview, the manager smiled and shook her hand. A week later, she got the job.",
      specificMeanings: {
        "nervous": "Gergin",
        "interview": "Mülakat",
        "company": "Şirket",
        "suit": "Takım elbise",
        "arrived": "Vardı / Ulaştı",
        "skills": "Yetenekler",
        "previous": "Önceki",
        "experience": "Deneyim",
        "confidently": "Kendinden emin bir şekilde",
        "passion": "Tutku",
        "coding": "Kodlama / Yazılım",
        "manager": "Müdür",
        "shook": "Sıktı (El)",
      }),
  Paragraph(
      title: "Recycling and Nature",
      level: "B1",
      translation:
          "Gezegenimiz birçok çevresel sorunla karşı karşıya. Kirlilik ve atıklar doğayı yok ediyor. Geri dönüşüm yardım etmenin basit bir yoludur. Kağıdı, plastiği ve camı geri dönüştürebiliriz. Bir şeyleri çöpe atmak yerine onları tekrar kullanabiliriz. Ağaç dikmek de çok yararlıdır çünkü ağaçlar oksijen üretir. Küçük eylemler Dünyamızın geleceği için büyük bir fark yaratabilir.",
      content:
          "Our planet is facing many environmental problems. Pollution and waste are destroying nature. Recycling is a simple way to help. We can recycle paper, plastic, and glass. Instead of throwing things away, we can use them again. Planting trees is also very helpful because trees produce oxygen. Small actions can make a big difference for the future of our Earth.",
      specificMeanings: {
        "planet": "Gezegen",
        "facing": "Yüzleşmek",
        "environmental": "Çevresel",
        "pollution": "Kirlilik",
        "waste": "Atık",
        "destroying": "Yok ediyor",
        "recycling": "Geri dönüşüm",
        "paper": "Kağıt",
        "plastic": "Plastik",
        "glass": "Cam",
        "planting": "Dikmek",
        "produce": "Üretmek",
        "oxygen": "Oksijen",
        "actions": "Eylemler",
      }),
  Paragraph(
      title: "The Invention of the Airplane",
      level: "B1",
      translation:
          "Yüzyıllar boyunca insanlar kuşlar gibi uçmak istediler. Birçok insan denedi ve başarısız oldu. 1903'te Wright kardeşler tarih yazdı. İlk başarılı uçağı inşa ettiler. İlk uçuşları sadece 12 saniye sürdü ama dünyayı sonsuza dek değiştirdi. Bugün uçaklar uzak ülkelere sadece birkaç saat içinde seyahat etmemizi sağlıyor. Tüm zamanların en büyük icatlarından biridir.",
      content:
          "For centuries, humans wanted to fly like birds. Many people tried and failed. In 1903, the Wright brothers made history. They built the first successful airplane. Their first flight lasted only 12 seconds, but it changed the world forever. Today, airplanes allow us to travel to distant countries in just a few hours. It is one of the greatest inventions of all time.",
      specificMeanings: {
        "centuries": "Yüzyıllar",
        "humans": "İnsanlar",
        "failed": "Başarısız oldu",
        "history": "Tarih",
        "built": "İnşa etti",
        "successful": "Başarılı",
        "flight": "Uçuş",
        "lasted": "Sürdü",
        "forever": "Sonsuza dek",
        "distant": "Uzak",
        "inventions": "İcatlar",
      }),

  // ==========================================
  // B2 SEVİYESİ (İyi)
  // ==========================================
  Paragraph(
      title: "The Impact of Social Media",
      level: "B2",
      translation:
          "Sosyal medya iletişim kurma şeklimizde devrim yarattı. Dünyanın dört bir yanındaki arkadaşlarımız ve ailemizle anında bağlantı kurmamızı sağlıyor. Ancak olumsuz yanları da var. Birçok insan saatlerini akışları kaydırarak harcıyor, bu da bağımlılığa ve kaygıya yol açabiliyor. Dahası, internette mükemmel bir hayat sunma baskısı özgüveni olumsuz etkileyebilir. Dijital dünya ile gerçek hayattaki etkileşimler arasında bir denge bulmak çok önemlidir.",
      content:
          "Social media has revolutionized the way we communicate. It allows us to connect with friends and family across the globe instantly. However, it also has downsides. Many people spend hours scrolling through feeds, which can lead to addiction and anxiety. Furthermore, the pressure to present a perfect life online can negatively affect self-esteem. It is essential to find a balance between the digital world and real-life interactions.",
      specificMeanings: {
        "revolutionized": "Devrim yarattı",
        "communicate": "İletişim kurmak",
        "connect": "Bağlanmak",
        "globe": "Küre / Dünya",
        "instantly": "Anında",
        "downsides": "Olumsuz yanlar",
        "scrolling": "Kaydırmak (Ekranı)",
        "feeds": "Akışlar",
        "addiction": "Bağımlılık",
        "anxiety": "Kaygı",
        "pressure": "Baskı",
        "present": "Sunmak / Göstermek",
        "negatively": "Olumsuz yönde",
        "esteem": "Saygı / Özgüven",
        "essential": "Gerekli / Temel",
        "balance": "Denge",
        "interactions": "Etkileşimler",
      }),
  Paragraph(
      title: "The Great Wall of China",
      level: "B2",
      translation:
          "Çin Seddi tarihteki en etkileyici mimari başarılardan biridir. Çin imparatorluğunu istilalardan korumak için yüzyıllar boyunca inşa edilmiştir. Duvar dağları, çölleri ve ovaları geçerek binlerce kilometre boyunca uzanır. Uzaydan görülebilen tek insan yapımı yapı olduğu söylenir, ancak bu bir efsanedir. Bugün UNESCO Dünya Mirası listesindedir ve her yıl milyonlarca turisti kendine çeker.",
      content:
          "The Great Wall of China is one of the most impressive architectural feats in history. It was built over many centuries to protect the Chinese empire from invasions. The wall stretches for thousands of kilometers, crossing mountains, deserts, and plains. It is said to be the only man-made structure visible from space, although this is a myth. Today, it is a UNESCO World Heritage site and attracts millions of tourists every year.",
      specificMeanings: {
        "impressive": "Etkileyici",
        "architectural": "Mimari",
        "feats": "Ustalıklar / Başarılar",
        "protect": "Korumak",
        "empire": "İmparatorluk",
        "invasions": "İstilalar",
        "stretches": "Uzanır",
        "crossing": "Geçerek",
        "deserts": "Çöller",
        "plains": "Ovalar",
        "man-made": "İnsan yapımı",
        "structure": "Yapı",
        "visible": "Görünür",
        "myth": "Mit / Efsane",
        "heritage": "Miras",
        "site": "Alan / Bölge",
        "attracts": "Çeker (İlgi)",
      }),
  Paragraph(
      title: "Climate Change",
      level: "B2",
      translation:
          "İklim değişikliği önemli bir küresel sorundur. Fosil yakıtların yakılmasıyla açığa çıkan sera gazları nedeniyle Dünya'nın ortalama sıcaklığı yükseliyor. Bu, buzulların erimesine, deniz seviyelerinin yükselmesine ve kasırgalar ve kuraklıklar gibi aşırı hava olaylarına yol açıyor. Bilim insanları karbon salınımını azaltmak için hızlı hareket etmemiz gerektiği konusunda uyarıyor. Güneş ve rüzgar enerjisi gibi yenilenebilir enerji kaynakları, gezegenimizi gelecek nesiller için korumak adına hayati çözümlerdir.",
      content:
          "Climate change is a significant global challenge. The Earth's average temperature is rising due to greenhouse gases released by burning fossil fuels. This leads to melting ice caps, rising sea levels, and extreme weather events like hurricanes and droughts. Scientists warn that we must act quickly to reduce carbon emissions. Renewable energy sources like solar and wind power are vital solutions to protect our planet for future generations.",
      specificMeanings: {
        "climate": "İklim",
        "significant": "Önemli",
        "challenge": "Zorluk",
        "average": "Ortalama",
        "rising": "Yükselen",
        "greenhouse": "Sera",
        "released": "Salınan",
        "burning": "Yakma",
        "fossil": "Fosil",
        "fuels": "Yakıtlar",
        "leads": "Yol açar",
        "melting": "Erime",
        "caps": "Örtüler / Zirveler",
        "extreme": "Aşırı",
        "hurricanes": "Kasırgalar",
        "droughts": "Kuraklıklar",
        "warn": "Uyarmak",
        "emissions": "Salınımlar",
        "renewable": "Yenilenebilir",
        "vital": "Hayati",
        "generations": "Nesiller",
      }),
  Paragraph(
      title: "The Power of Music",
      level: "B2",
      translation:
          "Müzik, sınırları ve kültürleri aşan evrensel bir dildir. Neşeden hüzne kadar derin duyguları uyandırma gücüne sahiptir. Araştırmalar, müzik dinlemenin stresi azaltabileceğini ve zihinsel sağlığı iyileştirebileceğini gösteriyor. Bir enstrüman çalmak bilişsel yetenekleri ve hafızayı da geliştirir. Klasik, caz veya pop olsun, müzik insan toplumunda ve bireysel esenlikte ayrılmaz bir rol oynar.",
      content:
          "Music is a universal language that transcends borders and cultures. It has the power to evoke deep emotions, from joy to sadness. Research shows that listening to music can reduce stress and improve mental health. Playing an instrument also enhances cognitive abilities and memory. Whether it is classical, jazz, or pop, music plays an integral role in human society and individual well-being.",
      specificMeanings: {
        "universal": "Evrensel",
        "transcends": "Aşar / Ötesine geçer",
        "borders": "Sınırlar",
        "evoke": "Uyandırmak (His)",
        "emotions": "Duygular",
        "joy": "Neşe",
        "sadness": "Hüzün",
        "research": "Araştırma",
        "instrument": "Enstrüman",
        "enhances": "Geliştirir / Artırır",
        "cognitive": "Bilişsel",
        "abilities": "Yetenekler",
        "integral": "Bütünleyici / Ayrılmaz",
        "role": "Rol",
        "society": "Toplum",
        "well-being": "Esenlik / Refah",
      }),
  Paragraph(
      title: "Artificial Intelligence",
      level: "B2",
      translation:
          "Yapay Zeka (YZ) dünyayı hızla değiştiriyor. Siri gibi sanal asistanlardan sürücüsüz arabalara kadar makineler daha zeki hale geliyor. YZ, büyük miktarda veriyi insanlardan çok daha hızlı işleyebilir. Tıpta, doktorların hastalıkları daha erken teşhis etmesine yardımcı olur. Ancak YZ'nin insan işlerinin yerini almasıyla ilgili endişeler var. Toplum bu teknolojik ilerlemelere uyum sağlamalı ve bunların etik bir şekilde kullanılmasını sağlamalıdır.",
      content:
          "Artificial Intelligence (AI) is rapidly changing the world. From virtual assistants like Siri to self-driving cars, machines are becoming smarter. AI can process vast amounts of data much faster than humans. In medicine, it helps doctors diagnose diseases earlier. However, there are concerns about AI replacing human jobs. Society must adapt to these technological advancements and ensure they are used ethically.",
      specificMeanings: {
        "artificial": "Yapay",
        "intelligence": "Zeka",
        "rapidly": "Hızla",
        "virtual": "Sanal",
        "assistants": "Asistanlar",
        "process": "İşlemek",
        "vast": "Geniş / Büyük",
        "amounts": "Miktarlar",
        "medicine": "Tıp",
        "diagnose": "Teşhis etmek",
        "diseases": "Hastalıklar",
        "concerns": "Endişeler",
        "replacing": "Yerine geçme",
        "adapt": "Uyum sağlamak",
        "advancements": "İlerlemeler",
        "ensure": "Sağlamak / Garanti etmek",
        "ethically": "Etik olarak",
      }),

  // ==========================================
  // C1 SEVİYESİ (İleri)
  // ==========================================
  Paragraph(
      title: "Globalization",
      level: "C1",
      translation:
          "Küreselleşme, ekonomilerin, kültürlerin ve nüfusların artan karşılıklı bağlılığını ifade eder. Teknoloji ve ulaşımdaki ilerlemeler, malların, bilginin ve insanların sınırlar ötesinde hızlı akışını kolaylaştırdı. Küreselleşme ekonomik fırsatlar yaratarak milyonlarca insanı yoksulluktan kurtarmış olsa da, zengin ile yoksul arasındaki uçurumu da genişletti. Eleştirmenler, bunun yerel gelenekleri aşındırdığını ve kültürü tek tipleştirdiğini savunuyor. Küresel entegrasyonun faydaları ile yerel kimliğin korunması arasında bir denge kurmak, 21. yüzyıl için karmaşık bir zorluk olmaya devam ediyor.",
      content:
          "Globalization refers to the increasing interconnectedness of economies, cultures, and populations. Advances in technology and transportation have facilitated the rapid flow of goods, information, and people across borders. While globalization has lifted millions out of poverty by creating economic opportunities, it has also widened the gap between the rich and the poor. Critics argue that it erodes local traditions and homogenizes culture. Balancing the benefits of global integration with the preservation of local identity remains a complex challenge for the 21st century.",
      specificMeanings: {
        "refers": "İfade eder",
        "interconnectedness": "Karşılıklı bağlılık",
        "facilitated": "Kolaylaştırdı",
        "flow": "Akış",
        "goods": "Mallar / Ürünler",
        "lifted": "Kaldırdı / Kurtardı",
        "poverty": "Yoksulluk",
        "widened": "Genişletti",
        "gap": "Uçurum / Boşluk",
        "critics": "Eleştirmenler",
        "argue": "İleri sürmek / Tartışmak",
        "erodes": "Aşındırır",
        "homogenizes": "Tek tipleştirir",
        "integration": "Bütünleşme",
        "preservation": "Koruma",
        "identity": "Kimlik",
        "complex": "Karmaşık",
      }),
  Paragraph(
      title: "The Psychology of Happiness",
      level: "C1",
      translation:
          "İnsanları gerçekten mutlu eden nedir? Psikologlar bu soruyu on yıllardır inceliyorlar. Yaygın inanışın aksine, zenginlik ve maddi varlıkların uzun vadeli mutluluk üzerinde sınırlı bir etkisi vardır. Bunun yerine, güçlü sosyal ilişkiler, bir amaç duygusu ve minnettarlık, esenliğin temel itici güçleridir. 'Hazcı uyum' kavramı, insanların büyük olumlu veya olumsuz yaşam olaylarına rağmen hızla istikrarlı bir mutluluk seviyesine döndüğünü öne sürer. Bu nedenle sürdürülebilir mutluluk, dışsal başarılardan ziyade içsel tatminden gelir.",
      content:
          "What makes people truly happy? Psychologists have studied this question for decades. Contrary to popular belief, wealth and material possessions have a limited impact on long-term happiness. Instead, strong social relationships, a sense of purpose, and gratitude are the key drivers of well-being. The concept of 'hedonic adaptation' suggests that humans quickly return to a stable level of happiness despite major positive or negative life events. Therefore, sustainable happiness comes from internal fulfillment rather than external achievements.",
      specificMeanings: {
        "truly": "Gerçekten",
        "decades": "On yıllar",
        "contrary": "Aksine",
        "belief": "İnanç",
        "wealth": "Zenginlik",
        "possessions": "Mülkler / Eşyalar",
        "limited": "Sınırlı",
        "impact": "Etki",
        "relationships": "İlişkiler",
        "purpose": "Amaç",
        "gratitude": "Minnettarlık",
        "drivers": "İtici güçler",
        "hedonic": "Hazcı",
        "adaptation": "Uyum",
        "stable": "İstikrarlı",
        "sustainable": "Sürdürülebilir",
        "internal": "İçsel",
        "fulfillment": "Tatmin / Tamamlanma",
        "external": "Dışsal",
        "achievements": "Başarılar",
      }),
  Paragraph(
      title: "The Future of Work",
      level: "C1",
      translation:
          "İş dünyası, otomasyon ve yapay zeka nedeniyle sarsıcı bir değişim geçiriyor. Rutin görevler giderek artan bir şekilde algoritmalar tarafından yerine getiriliyor, bu da kitlesel işsizlik korkularına yol açıyor. Ancak tarih, teknolojinin daha önce hayal bile edilemeyen yeni iş türleri yarattığını gösteriyor. Geleceğin iş gücünün, makinelerin kolayca taklit edemeyeceği yaratıcılık, duygusal zeka ve eleştirel düşünme gibi sosyal becerilere öncelik vermesi gerekecek. Yaşam boyu öğrenme ve uyum sağlama yeteneği, modern çağda mesleki hayatta kalmak için gerekli olacaktır.",
      content:
          "The landscape of work is undergoing a seismic shift due to automation and artificial intelligence. Routine tasks are increasingly being performed by algorithms, leading to fears of mass unemployment. However, history shows that technology also creates new types of jobs that were previously unimaginable. The workforce of the future will need to prioritize soft skills such as creativity, emotional intelligence, and critical thinking—traits that machines cannot easily replicate. Lifelong learning and adaptability will be essential for professional survival in the modern era.",
      specificMeanings: {
        "landscape": "Manzara / Alan",
        "undergoing": "Geçiriyor (Süreç)",
        "seismic": "Sarsıcı (Sismik)",
        "shift": "Değişim / Kayma",
        "automation": "Otomasyon",
        "routine": "Rutin",
        "tasks": "Görevler",
        "algorithms": "Algoritmalar",
        "fears": "Korkular",
        "unemployment": "İşsizlik",
        "previously": "Önceden",
        "unimaginable": "Hayal edilemez",
        "workforce": "İş gücü",
        "prioritize": "Öncelik vermek",
        "creativity": "Yaratıcılık",
        "critical": "Eleştirel",
        "traits": "Özellikler",
        "replicate": "Kopyalamak / Taklit etmek",
        "lifelong": "Hayat boyu",
        "survival": "Hayatta kalma",
        "era": "Çağ / Dönem",
      }),
  Paragraph(
      title: "Minimalism",
      level: "C1",
      translation:
          "Minimalizm, daha fazla özgürlüğe ulaşmak için daha azla yaşamayı teşvik eden bir yaşam tarzı hareketidir. Mutluluğu mülkiyetle eş tutan tüketim kültürüne meydan okur. Minimalistler, fiziksel fazlalıklardan kurtularak zihinsel berraklık kazandıklarını ve stresi azalttıklarını iddia ederler. Felsefe, maddi malların ötesine geçerek zaman yönetimi ve ilişkilere kadar uzanır ve bireyleri yalnızca hayatlarına gerçekten değer katan şeylere odaklanmaya teşvik eder. Nihayetinde minimalizm, eşya biriktirmek yerine deneyimlere ve bağlantılara yer açmakla, yani bilinçli tercihlerle ilgilidir.",
      content:
          "Minimalism is a lifestyle movement that encourages living with less to achieve more freedom. It challenges the consumerist culture that equates happiness with ownership. By decluttering physical possessions, minimalists claim to gain mental clarity and reduce stress. The philosophy extends beyond material goods to time management and relationships, urging individuals to focus only on what truly adds value to their lives. Ultimately, minimalism is about intentionality—making room for experiences and connections rather than accumulating things.",
      specificMeanings: {
        "lifestyle": "Yaşam tarzı",
        "movement": "Akım / Hareket",
        "encourages": "Teşvik eder",
        "freedom": "Özgürlük",
        "challenges": "Meydan okur",
        "consumerist": "Tüketici",
        "equates": "Eş tutar",
        "ownership": "Sahiplik",
        "decluttering": "Sadeleştirme",
        "claim": "İddia etmek",
        "clarity": "Berraklık / Açıklık",
        "philosophy": "Felsefe",
        "extends": "Uzanır / Genişler",
        "urging": "Teşvik ederek",
        "ultimately": "Nihayetinde",
        "intentionality": "Bilinçlilik / Kasıtlılık",
        "room": "Yer / Alan",
        "accumulating": "Biriktirmek",
      }),
  Paragraph(
      title: "Space Exploration Ethics",
      level: "C1",
      translation:
          "İnsanlık, çok gezegenli bir tür olmanın eşiğinde dururken etik sorular ortaya çıkıyor. Mars'ı kolonileştirmeli miyiz? Asteroitlerde bulunan kaynakların sahibi kim? Bazıları, bilinci evrene yaymak ve keşfetmek için ahlaki bir yükümlülüğümüz olduğunu savunuyor. Diğerleri ise uzay yolculuğuna trilyonlar yatırmadan önce Dünya'daki yoksulluk ve iklim değişikliği gibi acil sorunları çözmemiz gerektiğini ileri sürüyor. Dahası, diğer gezegenlerin Dünya mikroplarıyla kirlenme potansiyeli, dünya dışı ekosistemlerin korunmasıyla ilgili endişeleri artırıyor.",
      content:
          "As humanity stands on the brink of becoming a multi-planetary species, ethical questions arise. Should we colonize Mars? Who owns the resources found on asteroids? Some argue that we have a moral obligation to explore and expand consciousness throughout the universe. Others contend that we must first solve the pressing issues on Earth, such as poverty and climate change, before investing trillions in space travel. Furthermore, the potential contamination of other planets with Earth's microbes raises concerns about preserving extraterrestrial ecosystems.",
      specificMeanings: {
        "humanity": "İnsanlık",
        "brink": "Eşik / Kıyı",
        "species": "Tür",
        "ethical": "Etik",
        "arise": "Ortaya çıkmak",
        "colonize": "Kolonileştirmek",
        "resources": "Kaynaklar",
        "asteroids": "Göktaşları",
        "obligation": "Yükümlülük",
        "consciousness": "Bilinç",
        "universe": "Evren",
        "contend": "İleri sürmek / Savunmak",
        "pressing": "Acil / Baskılayan",
        "investing": "Yatırım yapmak",
        "trillions": "Trilyonlar",
        "contamination": "Kirlenme / Bulaşma",
        "microbes": "Mikroplar",
        "preserving": "Koruma",
        "extraterrestrial": "Dünya dışı",
        "ecosystems": "Ekosistemler",
      }),
];
