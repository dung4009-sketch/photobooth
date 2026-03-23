Photobooth chạy 1 chạm trên Windows

Gói này dùng PowerShell có sẵn của Windows, nên không cần Python.

CÁCH DÙNG
1) Giữ các file trong cùng một thư mục.
2) Bấm đúp start_photobooth.bat hoặc start_hidden.vbs
3) Trình duyệt sẽ tự mở:
   http://localhost:8080/đang%20chỉnh.html
4) Cấp quyền camera khi trình duyệt hỏi.

LƯU Ý
- Đừng mở file bằng Facebook/Zalo/Messenger hoặc content://
- Hãy mở đúng bằng localhost để camera hoạt động
- Nếu Windows chặn script, hãy chạy start_photobooth.bat bằng Run as administrator một lần

DỪNG SERVER
- Mở Task Manager và tắt tiến trình powershell.exe đang chạy server
