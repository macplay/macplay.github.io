# DONOT RUN THIS "SCRIPT" DIRECTLY! (unfinished work) see it as a refer

# https://letsencrypt.org/zh-cn/docs/certificates-for-localhost/
# https://support.symantec.com/us/en/article.TECH242030.html
# https://www.ibm.com/support/knowledgecenter/en/SSCRJU_4.1.1/com.ibm.streams.cfg.doc/doc/creating-pkcs12-file.html

openssl genrsa -out private.key 2048
# openssl req -x509 -newkey rsa:2048 -keyout private.key -out localhost.pem -days 365 -nodes -subj '/CN=localhost'
openssl req -new -key private.key -sha256 -out localhost.csr \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
openssl x509 -req -days 365 -in localhost.csr -signkey private.key -sha256 -out localhost.crt
openssl x509 -in localhost.crt -out localhost.pem -outform PEM
