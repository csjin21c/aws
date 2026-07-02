aws ec2 create-vpc \
  --instance-tenancy 'default' \
  --cidr-block '10.0.0.0/16' \
  --tag-specifications '{ \
    "resourceType":"vpc",\
    "tags":[\
      {"key":"Name","value":"ian-vpc"},\
      {"key":"Username","value":"ian"},\
      {"key":"Project","value":"hands-on-kr"}\
    ]\
  }' 