FROM ubuntu:22.04

# تثبيت التبعات الأساسية وخادم ويب بسيط
RUN apt-get update && apt-get install -y wget tar libasound2 python3 && rm -rf /var/lib/apt/lists/*

# إعداد المجلد والتحميل
WORKDIR /opt/teamtalk
RUN wget https://bearware.dk/teamtalk/v5.21/teamtalk-v5.21-ubuntu22-x86_64.tgz \
    && tar -xvf teamtalk-v5.21-ubuntu22-x86_64.tgz --strip-components=1 \
    && rm teamtalk-v5.21-ubuntu22-x86_64.tgz

# نسخ ملف الإعدادات
COPY tt5srv.xml /opt/teamtalk/tt5srv.xml

# إنشاء مجلد الملفات
RUN mkdir -p /opt/teamtalk/files

# فتح المنافذ
EXPOSE 8080/tcp
EXPOSE 10333/tcp
EXPOSE 10333/udp

# إنشاء سكربت تشغيل مزدوج (TeamTalk + Web Server لفحص الصحة)
RUN echo '#!/bin/bash\n\
python3 -m http.server 8080 & \n\
./server/tt5srv -nd -c tt5srv.xml\n\
' > /opt/teamtalk/entrypoint.sh && chmod +x /opt/teamtalk/entrypoint.sh

# تشغيل السيرفر عبر السكربت
CMD ["/opt/teamtalk/entrypoint.sh"]
