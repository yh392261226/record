#!/bin/bash
from_name="abc@gmail.com"  
from="abc@gmail.com"  
to="bcd@gmail.com"  
email_title="Test Mail"  
email_content="Content"  
email_subject="test title"  
  
echo -e "To: \"${email_title}\" <${to}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t 
