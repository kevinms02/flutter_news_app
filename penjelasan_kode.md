# Perbandingan dan Penjelasan Versi Kode Saat Ini

Dokumen ini menjelaskan perbedaan utama dari *starter code* standar Flutter (atau kode paling awal) dengan versi akhir dari Aplikasi **Kevin News**, serta menyoroti fitur-fitur apa saja yang sudah ditambahkan.

---

## 🏗️ 1. Restrukturisasi dan Pemisahan Folder (Architecture)
Berbeda dengan struktur bawaan Flutter yang hanya mengandalkan di satu file `main.dart`, kode saat ini telah distrukturisasi menggunakan pola arsitektur layer yang jauh lebih rapi dan dapat di-maintain:
- **`lib/model/post.dart`** : Menampung model data `Post` sebagai *Blueprint* dari objek yang diambil melalui API (terdiri dari atribut `id`, `title`, dan `body`). Terdapat `factory method` untuk mengubah _JSON map_ menjadi object `Post`.
- **`lib/service/api_service.dart`** : Service layer khusus. Tempat berkumpulnya *logic* jaringan HTTP request (GET method) ke **JSONPlaceholder**. Memisahkan fungsi jaringan dari UI.
- **`lib/pages/home_page.dart`** : Memisahkan UI halaman utama secara utuh agar `main.dart` menjadi sangat ringkas (hanya mengurus tema dan inisiasi aplikasi).
- **`lib/pages/detail_page.dart`** : Halaman independen khusus untuk menampilkan detail isi berita.

## 🌐 2. Integrasi Data Eksternal (Lebih Dinamis)
- **REST API HTTP Request**: Jika sebelumnya berpotensi hanya list statis atau counter default, sekarang ia memutar request sungguhan ke `https://jsonplaceholder.typicode.com/posts` menggunakan file terpisah dengan pustaka package `http`. Data menjadi dinamis, serta dilindungi pola `FutureBuilder` untuk menampilkan panah *loading* lingkaran (indicator loading interaktif) jika koneksi internet berjalan.

## 🎨 3. Peningkatan Estetika & UX (Desain Premium)
Terdapat perombakan masif pada sisi tampilan dari sekadar Material dasar menjadi lebih modern:
- **Google Fonts (Poppins)**: Diterapkan sebagai standarisasi typografi utama yang sangat rapi dan elegan lewat setelan `GoogleFonts.poppinsTextTheme()`.
- **Tema Custom (Theming di `main.dart`)**: Pewarnaan dengan harmonisasi Blue Light & Dark (`Color(0xFF64B5F6)` dan `Color(0xFF1565C0)`) merata diterapkan ke warna background aplikasi, elemen form input (dengan efek fokus OutlineInputBorder), serta border radius shadow untuk tema Card.
- **Header Kustom "Non-Folding"**: Menyingkirkan `AppBar` tradisional dan menggantinya dengan Header buatan (*Container* dengan gradient dan rounded bottom edges) yang **statis/tetap (fixed)**, sehingga tampak elegan dan kokoh walau Grid di *scroll* ke bawah.
- **Beautiful Accent Custom Card**: Desain "Kartu Berita" di homepage dibagi proporsinya (50:50). Separuh bagian atas menggunakan palet gradient *Accent Color* yang bervariasi otomatis (biru, hijau, jingga, ungu, dll.) yang dipadukan dengan icon News.

## ⚙️ 4. Fungsionalitas Interaktif Baru
Banyak implementasi fitur logik mutakhir yang ditanam di halaman beranda (`home_page.dart`):
- **Real-Time Live Search**: *Search Bar* yang membaca ketikan user dan segera memfilter `List<Post>` di lokal memori secara _real-time_ tanpa harus menekan tombol submit (menggunakan metode `onChanged`).
- **Fitur Live Sorting / Filter Toggle**: Icon di pojok layar search yang bila ditekan (`_toggleFilter`) dapat mengurutkan berita:
    1. Berdasarkan abjad (**A - Z**).
    2. Berdasarkan rilis / ID Terbesar (**Terbaru / Descending**).
   Ditambah, ada animasi muncul Notifikasi kecil (`SnackBar`) untuk memberi tahu user *Sorting Type* mana yang sedang diaktifkan.
- **Total Result Label**: Info dinamis yang terus merubah label "*{X} berita ditemukan*" menyesuaikan filter pencarian yang berjalan.

## 📱 5. Responsivitas Ekstrem / Multi-Platform (Responsive UI)
- Sebelumnya UI card di Flutter mungkin memanjang berantakan hingga mengotori lebar layar jika dijalankan di Browser Web atau Tablet.
- **Penambahan `LayoutBuilder`**: `GridView` mendeteksi limit maksimal lebar layar (*constraints*) untuk memperhitungkan jumlah kolom secara matematis. 
    - Layar HP: 2 Kolom
    - Lebar Sedang (Tablet): 3-4 Kolom
    - Lebar Layar Besar (Web/Laptop UI) : sampai dengan 5/6 Kolom
- Hal ini membuat susunan berita dan gambar *dummy* tetap profesional serta kompak tidak peduli di *device* mana ia dijalankan.

## ➡️ 6. Navigasi Antar Halaman (Routing Implementation)
- Penggunaan `Navigator.push` disertai `MaterialPageRoute`. Perpindahan dari *Home* ke *Detail* dengan membawa (melempar parameter payload object) `Post post` ke UI *Detail*, agar detail page hanya merender isi lengkap (Body text) dari berita tersebut. 

---
**Kesimpulan**: Aplikasi sudah berkembang penuh dari aplikasi starter *"Counter"* kosong menjadi prototype *Aplikasi Berita (News Aggregator)* skala nyata berbasis HTTP fetch, Responsif Grid-list, memiliki Fitur filter/Pencarian interaktif, dan dibalut desain material modern.
