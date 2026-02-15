FROM ubuntu:22.04

# تثبيت التبعات الأساسية
RUN apt-get update && apt-get install -y wget tar libasound2 && rm -rf /var/lib/apt/lists/*

# إعداد المجلد والتحميل
WORKDIR /opt/teamtalk
RUN wget https://bearware.dk/teamtalk/v5.21/teamtalk-v5.21-ubuntu22-x86_64.tgz \
    && tar -xvf teamtalk-v5.21-ubuntu22-x86_64.tgz --strip-components=1 \
    && rm teamtalk-v5.21-ubuntu22-x86_64.tgz

# نسخ ملف الإعدادات (سنقوم بإنشائه لاحقاً)
COPY tt5srv.xml /opt/teamtalk/tt5srv.xml

# إنشاء مجلد الملفات
RUN mkdir -p /opt/teamtalk/files

# فتح المنافذ (المنفذ 10333 هو الافتراضي)
EXPOSE 10333/tcp
EXPOSE 10333/udp
EXPOSE 8080/tcp

# تشغيل السيرفر
CMD ["./server/tt5srv", "-nd", "-c", "tt5srv.xml"]
