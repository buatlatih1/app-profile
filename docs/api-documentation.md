# 📖 Dokumentasi REST API v1 (Untuk Flutter Mobile & Web)

Base URL:
`http://localhost:8000/api/v1` (Lokal) atau domain produksi Anda.

Header Wajib:
```http
Accept: application/json
Content-Type: application/json
```

---

## 📑 Ringkasan Endpoint

| No | Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|---|
| 1 | `GET` | `/posts` | Daftar artikel/berita (pagination, search, category filter) | Publik |
| 2 | `GET` | `/posts/{slug}` | Detail artikel berita + auto increment view count | Publik |
| 3 | `GET` | `/categories` | Daftar kategori artikel dengan total post | Publik |
| 4 | `GET` | `/categories/{slug}` | Detail satu kategori | Publik |
| 5 | `GET` | `/pages` | Daftar halaman statis aktif | Publik |
| 6 | `GET` | `/pages/{slug}` | Detail halaman statis (Tentang Kami, Visi Misi, dll) | Publik |
| 7 | `GET` | `/slides` | Daftar slide banner beranda aktif | Publik |
| 8 | `GET` | `/menus/{location}` | Struktur menu navigasi (`header`, `footer`, `sidebar`) | Publik |
| 9 | `GET` | `/settings` | Pengaturan instansi (nama, kontak, sosmed, logo) | Publik |
| 10 | `GET` | `/question-topics` | Daftar topik pertanyaan publik | Publik |
| 11 | `GET` | `/questions` | Daftar pertanyaan yang sudah dijawab secara resmi | Publik |
| 12 | `POST` | `/questions` | Kirim pertanyaan / aspirasi baru dari warga (Rate Limited) | Publik |
| 13 | `GET` | `/faqs` | Daftar tanya jawab populer (FAQ) | Publik |

---

## 1. Modul CMS

### `GET /api/v1/posts`
Query Parameters:
- `page` (int, default: 1)
- `per_page` (int, default: 10, max: 50)
- `category` (string, filter slug kategori, misal: `berita-utama`)
- `q` (string, pencarian judul & isi)
- `featured` (boolean: 1/0)

Response Contoh:
```json
{
  "data": [
    {
      "id": 1,
      "title": "Peluncuran Aplikasi Layanan Digital Masyarakat Terpadu",
      "slug": "peluncuran-aplikasi-layanan-digital-masyarakat-terpadu",
      "summary": "Pemerintah resmi merilis portal aplikasi layanan terpadu...",
      "image": "http://localhost:8000/storage/posts/example.jpg",
      "category": {
        "id": 1,
        "name": "Berita Utama",
        "slug": "berita-utama"
      },
      "author": {
        "name": "Admin Portal"
      },
      "view_count": 343,
      "is_featured": true,
      "published_at": "2026-11-04T02:00:00.000000Z"
    }
  ],
  "links": { ... },
  "meta": { "current_page": 1, "last_page": 1, "total": 5 }
}
```

---

### `POST /api/v1/questions`
Mengirim pertanyaan dari masyarakat. Dilengkapi rate limiter `10 request / menit` per IP.

Request Body:
```json
{
  "topic_id": 1,
  "name": "Budi Santoso",
  "email": "budi.santoso@example.com",
  "phone": "081234567890",
  "subject": "Pertanyaan Terkait Jadwal Pelayanan",
  "body": "Selamat pagi admin, apakah ada pelayanan loket di hari Sabtu?"
}
```

Response Berhasil (HTTP 201):
```json
{
  "message": "Pertanyaan Anda berhasil dikirim. Tim kami akan menelaah dan memberikan tanggapan melalui email.",
  "data": {
    "id": 12,
    "subject": "Pertanyaan Terkait Jadwal Pelayanan",
    "status": "pending",
    "created_at": "2026-11-04T03:00:00.000000Z"
  }
}
```

---

### `GET /api/v1/menus/{location}`
Lokasi yang tersedia: `header`, `footer`, `sidebar`.

Response Contoh:
```json
{
  "data": {
    "id": 1,
    "name": "Menu Utama (Header)",
    "location": "header",
    "items": [
      {
        "id": 1,
        "label": "Beranda",
        "url": "/",
        "type": "custom",
        "sort_order": 1,
        "children": []
      },
      {
        "id": 2,
        "label": "Tentang Kami",
        "url": "/page/tentang-kami",
        "type": "page",
        "sort_order": 2,
        "children": []
      }
    ]
  }
}
```

---

## 📱 Tips Integrasi Flutter

1. **Model Generasi**:
   Gunakan `json_serializable` atau `freezed` pada Flutter untuk memetakan JSON di atas.
2. **CORS**:
   Sudah dikonfigurasi aktif untuk `api/*` dengan semua HTTP verbs (`GET`, `POST`, `OPTIONS`).
3. **Penyimpanan Gambar**:
   Semua URL gambar pada properti `image` sudah langsung berbentuk URL absolut (`http://.../storage/...`) sehingga dapat langsung dipakai pada `Image.network(item.image)`.

