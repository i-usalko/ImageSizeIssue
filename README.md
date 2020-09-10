## Compress/decompress test

### OpenCV3
```
cd opencv3
./buildew
./venv/bin/python3 test.py
```

### OpenCV4

```
cd opencv4
./buildew
.venv/bin/python3 test.py
```

1. Not compressed images available in December 2019
2. Example of images before install new version of ImageDecompressionAgent < 10Jun2020
3. Example of images after install new version of ImageDecompressionAgent > 10Jun2020


Elasticsearch query:
```
POST /images/_search
{
   "size":0,
   "aggs":{
      "filter":{
         "filter":{
            "bool":{
               "must":[
                  {
                     "range":{
                        "ServerImageTime":{
                           "gte":"2020-06-01",
                           "lte":"2020-07-01"
                        }
                     }
                  },
                  {
                     "range":{
                        "FileSizeInBytes":{
                           "gt":0
                        }
                     }
                  }
               ]
            }
         },
         "aggs":{
            "days":{
               "date_histogram":{
                  "field":"ServerImageTime",
                  "interval":"1d"
               },
               "aggs":{
                  "avg_size":{
                     "avg":{
                        "field":"FileSizeInBytes"
                     }
                  }
               }
            }
         }
      }
   }
}
```
