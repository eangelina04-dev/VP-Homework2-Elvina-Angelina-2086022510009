# Composition: Star Wars Timeline

Dokumen ini mencatat setiap widget yang digunakan dalam project Star Wars Timeline.
Saya memilih Track B: The Lore & Discovery Hub (Directory & Explorer) dan membuat aplikasi untuk menjelajahi kronologi peristiwa Star Wars berdasarkan era, khusus film Episode I-IX.

Komposisinya dimulai dari widget layar utama (`TimelineScreen`) yang merakit lima widget hasil ekstraksi. Berikut fungsi tiap widget:

- `TimelineScreen`: layar utama.
- `TimelineSearchField`: kolom pencarian untuk mencari peristiwa berdasarkan judul atau ringkasan.
- `EraFilterChips`: baris chip untuk menyaring daftar peristiwa berdasarkan era (Semua, Prequel Era, Original Trilogy, Sequel Era).
- `EraHeader`: judul pemisah yang muncul setiap pergantian era di dalam daftar.
- `TimelineEntryCard`: kartu untuk satu peristiwa, berisi tahun, jenis media, judul, ringkasan, dan tombol favorit.
- `EmptyResultsView`: dipakai saat hasil pencarian kosong, atau saat mode favorit aktif tetapi belum ada peristiwa yang difavoritkan.

## TimelineScreen

`TimelineScreen` bukan hasil ekstraksi, tetapi widget inilah yang merakit semua widget lain. `TimelineScreen` adalah satu-satunya **Stateful Widget** karena ia menyimpan state yang berubah selama app berjalan. Saat state berubah, ia memanggil `setState` supaya Flutter membangun ulang tampilannya.

State yang dipakai bersama dan disimpan di widget ini:

1. `_query` (String, awalnya `''`)
  - Dipakai untuk menyaring daftar. Hanya entri yang judul atau ringkasannya mengandung kata kunci yang ditampilkan.
  - Dipicu oleh: `TimelineSearchField` lewat callback `onChanged`. Perubahannya dijalankan oleh `TimelineScreen` lewat `setState`.

2. `_selectedEra` (String?, awalnya `null`)
  - Dipakai untuk menyaring daftar berdasarkan era. Nilainya juga dikirim kembali ke `EraFilterChips` supaya chip yang aktif tampak terpilih. Nilai `null` berarti semua era ditampilkan.
  - Dipicu oleh: `EraFilterChips` lewat callback `onSelected`. Perubahannya dijalankan oleh `TimelineScreen` lewat `setState`.

3. `_showFavoritesOnly` (bool, awalnya `false`)
  - Dipakai untuk menyaring daftar, memilih ikon tombol (bintang kosong atau penuh), dan menentukan pesan yang dikirim ke `EmptyResultsView`.
  - Dipicu oleh: tombol bintang di AppBar (bagian dari `TimelineScreen`, bukan widget terpisah).

4. `_favoriteIds` (Set<String>, awalnya kosong)
  - Dipakai untuk menentukan `isFavorite` tiap kartu (`_favoriteIds.contains(row.id)`) dan menyaring daftar saat mode favorit aktif.
  - Dipicu oleh: `TimelineEntryCard` lewat callback `onFavoriteToggled(id)`, yang memanggil `_toggleFavorite` di `TimelineScreen`.

5. `_isLoading` (bool, awalnya `true`)
  - Dipakai untuk memilih isi body: spinner saat `true`, atau daftar atau tampilan kosong saat `false`.
  - Diubah oleh: `TimelineScreen` sendiri. `_loadData()` menunggu 0,8 detik lalu mengubahnya menjadi `false`.

### Bukan state: `_filteredEntries`

Daftar hasil dihitung dari state di atas setiap `build()`, tidak disimpan. Kalau disimpan sebagai variabel sendiri, daftar harus diperbarui setiap kali salah satu dari tiga state filter berubah, dan ada risiko terlewat. Dengan dihitung ulang, daftar selalu cocok dengan state.

## Widget yang diekstrak

### `TimelineEntryCard`
- **Trigger:** reuse. Dibuat satu kali per entri, jadi muncul sebanyak jumlah data.
- **Owns:** tidak ada state. Hanya menampilkan `entry` dan `isFavorite` yang diterimanya. (**Stateless Widget**)
- **Reports upward:** `onTap()` saat kartu diketuk (saat ini belum dihubungkan ke layar detail) dan `onFavoriteToggled(String id)` saat bintang diketuk.

### `EraHeader`
- **Trigger:** reuse. Muncul sekali di setiap pergantian era.
- **Owns:** tidak ada; hanya menampilkan nama era. (**Stateless Widget**)
- **Reports upward:** tidak ada. Widget ini murni tampilan.

### `TimelineSearchField`
- **Trigger:** readability. Hanya dipakai sekali, tetapi memisahkan konfigurasi `SearchBar` (hint, ikon) menjaga `build()` layar tetap pendek.
- **Owns:** tidak ada state di kode ini. Teks yang sedang diketik disimpan internal oleh `SearchBar`. (**Stateless Widget**)
- **Reports upward:** `onChanged(String query)` setiap teks berubah.

### `EraFilterChips`
- **Trigger:** readability. Baris chip yang bisa digulir horizontal beserta perulangan era akan membuat `build()` layar panjang jika ditulis langsung.
- **Owns:** tidak ada state. Menerima `eras` dan `selectedEra`. (**Stateless Widget**)
- **Reports upward:** `onSelected(String? era)`; `null` berarti "Semua".

### `EmptyResultsView`
- **Trigger:** readability. Tampilan ikon dan dua teks untuk kondisi kosong dipisahkan supaya percabangan loading / kosong / berisi di `build()` mudah dibaca.
- **Owns:** tidak ada state. Menerima `message` sehingga satu widget melayani dua kondisi (pencarian tidak ditemukan dan belum ada favorit). (**Stateless Widget**)
- **Reports upward:** tidak ada.

## Catatan

- Tidak ada widget anak yang menyimpan state bersama. Semuanya menerima nilai lewat constructor dan melapor lewat callback.
- Tiga dari lima ekstraksi widget dipicu readability, bukan reuse. Widget tersebut dipakai sekali untuk menjaga `build()` tetap terbaca.