## Table of Contents
1. [문서 개요](#1)
  - 1.1. [목적](#11)
  - 1.2. [범위](#12)
  - 1.3. [시스템 구성도](#13)
  - 1.4. [참고자료](#14)
2. [Sample Web App 연동 Pinpoint 연동](#2)
  - 2.1. [Sample Web App 설치](#21)
  - 2.2. [Sample Web App에 서비스 확인](#22)

# <div id='1'> 1. 문서 개요
### <div id='11'> 1.1. 목적

본 문서(SaaS 모니터링 Agent 빌드팩 설치 가이드)는 전자정부표준프레임워크 기반의 PaaS-TA에서 제공되는 서비스팩인 Pinpoint 빌드팩을 Bosh2.0을 이용하여 설치 하는 방법과 PaaS-TA의 SaaS 형태로 제공하는 Application 에서 Pinpoint 서비스를 사용하는 방법을 기술하였다.
PaaS-TA 4.6 버전부터는 Bosh2.0 기반으로 deploy를 진행하며 기존 Bosh1.0 기반으로 설치를 원할경우에는 PaaS-TA 3.1 이하 버전의 문서를 참고한다.

### <div id='12'> 1.2. 범위
설치 범위는 SaaS 모니터링 Pinpoint 빌드팩을 검증하기 위한 기본 설치를 기준으로 작성하였다.

### <div id='13'> 1.3. 시스템 구성도

본 문서의 설치된 시스템 구성도입니다. Pinpoint APM Server 사전에 구성을 전제로 한다.  

![시스템구성도][pinpoint_image_01]

<table>
  <tr>
    <th>구분</th>
    <th>스펙</th>
  </tr>
  <tr>
  <td>spring-music App</td><td>2vCPU / 1GB RAM</td>
  </tr>
</table>

### <div id='14'> 1.4. 참고자료
[**http://bosh.io/docs**](http://bosh.io/docs)  
[**http://docs.cloudfoundry.org/**](http://docs.cloudfoundry.org/)

#  <div id='2'> 2. Sample Web App 연동 Pinpoint Collector 연동

Web App은 개방형 클라우드 플랫폼에 배포되며 Pinpoint Collector Bind를 한 상태에서 사용이 가능하다.
Web App은 Pinpoint 에이전트 와의 통합을 제공하는 Cloud Foundry의 최종 빌드 팩입니다. 
이 빌드 팩은 java-buildpack 과 같은 다중 빌드 팩을 지원하는 최종 빌드 팩에서 작동합니다.

Pinpoint Java Build Pack Git 주소 : https://github.com/PaaS-TA/SAAS-BUILDPACK-MASTER.git


### <div id='21'> 2.1. Sample Web App 

spring-music Web App은 PaaS-TA에 App으로 배포가 된다. 배포된
App에 endpoint url을 통해 브라우저로 해당 App을 실행시 Pinpoint APM 서버
에서 수집된 정보로 모니터링할 수 있다.  


-   spring-music App을 이용하여 Pinpoint 모니터링을 테스트 하였다.
-   Sample App(spring-music) ./build/lib 경로에 제공하고, 별도으로 App은  –p 옵션을 주어 path을 지정 한다.
-   Pinpoint Collector 서버의 IP를 환경변수 --var 옵션을 주어 evn PINPOINT_COLLECTOR_IP 값을 지정하여 push 한다. 

```
$ cf push -f manifest.yaml -p ./build/spring-music.jar --var PINPOINT_COLLECTOR_IP=13.125.236.133
```

```
Pushing from manifest to org rex-org / space rex-space as admin...
Using manifest file manifest.yaml
Getting app info...
Updating app with these attributes...
  name:                spring-music
  path:                /home/ubuntu/workspace/user/arom/pinpoint/PaaS-TA/SAAS-BUILDPACK-MASTER/build/spring-music.jar
  buildpacks:
    https://github.com/PaaS-TA/SAAS-BUILDPACK-MASTER
  command:             JAVA_OPTS="-agentpath:$PWD/.java-buildpack/open_jdk_jre/bin/jvmkill-1.16.0_RELEASE=printHeapHistogram=1 -Djava.io.tmpdir=$TMPDIR -javaagent:$PWD/.java-buildpack/pinpoint_agent/pinpoint-bootstrap-1.8.4.jar -Dpinpoint.agentId=spring-music -Dpinpoint.applicationName=spring-music -Djava.ext.dirs=$PWD/.java-buildpack/container_security_provider:$PWD/.java-buildpack/open_jdk_jre/lib/ext -Djava.security.properties=$PWD/.java-buildpack/java_security/java.security $JAVA_OPTS" && CALCULATED_MEMORY=$($PWD/.java-buildpack/open_jdk_jre/bin/java-buildpack-memory-calculator-3.13.0_RELEASE -totMemory=$MEMORY_LIMIT -loadedClasses=24435 -poolType=metaspace -stackThreads=250 -vmOptions="$JAVA_OPTS") && echo JVM Memory Configuration: $CALCULATED_MEMORY && JAVA_OPTS="$JAVA_OPTS $CALCULATED_MEMORY" && MALLOC_ARENA_MAX=2 SERVER_PORT=$PORT eval exec $PWD/.java-buildpack/open_jdk_jre/bin/java $JAVA_OPTS -cp $PWD/. org.springframework.boot.loader.JarLauncher
  disk quota:          1G
  health check type:   port
  instances:           1
  memory:              1G
  stack:               cflinuxfs3
  services:
    pinpoint
  env:
    PINPOINT_AGENT_PACKAGE_DOWNLOAD_URL
-   PINPOINT_COLLECTOR_IP
+   PINPOINT_COLLECTOR_IP
    PINPOINT_CONFIG_URL
  routes:
    spring-music-proud-fossa.15.164.20.58.xip.io

Updating app spring-music...
Mapping routes...
Comparing local files to remote cache...
Packaging files to upload...
Uploading files...
 745.74 KiB / 745.74 KiB [====================================================================================================================================================================================================================] 100.00% 1s

Waiting for API to complete processing files...

Stopping app...

Staging app and tracing logs...
   Cell f635b024-c016-4bcb-b70b-45b8ad9c2878 creating container for instance c4478f4b-94e2-461e-8981-20405cbd9cb8
   Cell f635b024-c016-4bcb-b70b-45b8ad9c2878 successfully created container for instance c4478f4b-94e2-461e-8981-20405cbd9cb8
   Downloading app package...
   Downloading build artifacts cache...
   Downloaded build artifacts cache (59.3M)
   Downloaded app package (42.3M)
   -----> Java Buildpack e2d2933 | https://github.com/PaaS-TA/SAAS-BUILDPACK-MASTER#e2d2933
   -----> Downloading Jvmkill Agent 1.16.0_RELEASE from https://java-buildpack.cloudfoundry.org/jvmkill/bionic/x86_64/jvmkill-1.16.0-RELEASE.so (found in cache)
   -----> Downloading Open Jdk JRE 1.8.0_222 from https://java-buildpack.cloudfoundry.org/openjdk/bionic/x86_64/openjdk-jre-1.8.0_222-bionic.tar.gz (found in cache)
          Expanding Open Jdk JRE to .java-buildpack/open_jdk_jre (1.0s)
          JVM DNS caching disabled in lieu of BOSH DNS caching
   -----> Downloading Open JDK Like Memory Calculator 3.13.0_RELEASE from https://java-buildpack.cloudfoundry.org/memory-calculator/bionic/x86_64/memory-calculator-3.13.0-RELEASE.tar.gz (found in cache)
          Loaded Classes: 18664, Threads: 250
   -----> Downloading Pinpoint Agent 1.3.0 from https://raw.githubusercontent.com/yunjaecho/PINPOINT-BUILDPACK-MASTER/master/pinpoint_agent_repo/pinpoint-agent-1.8.4.zip (found in cache)
          Expanding Pinpoint Agent to .java-buildpack/pinpoint_agent (0.1s)
   [PinpointAgent]                  INFO  pinpoint_config_uri  https://raw.githubusercontent.com/yunjaecho/PINPOINT-BUILDPACK-MASTER/master/pinpoint.config
          downloading pinpoint.config to .java-buildpack/pinpoint_agent (0.4s)
   -----> Downloading Client Certificate Mapper 1.8.0_RELEASE from https://java-buildpack.cloudfoundry.org/client-certificate-mapper/client-certificate-mapper-1.8.0-RELEASE.jar (found in cache)
   -----> Downloading Container Security Provider 1.16.0_RELEASE from https://java-buildpack.cloudfoundry.org/container-security-provider/container-security-provider-1.16.0-RELEASE.jar (found in cache)
   -----> Downloading Spring Auto Reconfiguration 2.8.0_RELEASE from https://java-buildpack.cloudfoundry.org/auto-reconfiguration/auto-reconfiguration-2.8.0-RELEASE.jar (found in cache)
   Exit status 0
   Uploading droplet, build artifacts cache...
   Uploading droplet...
   Uploading build artifacts cache...
   Uploaded build artifacts cache (59.3M)
   Uploaded droplet (101.6M)
   Uploading complete
   Cell f635b024-c016-4bcb-b70b-45b8ad9c2878 stopping instance c4478f4b-94e2-461e-8981-20405cbd9cb8
   Cell f635b024-c016-4bcb-b70b-45b8ad9c2878 destroying container for instance c4478f4b-94e2-461e-8981-20405cbd9cb8
   Cell f635b024-c016-4bcb-b70b-45b8ad9c2878 successfully destroyed container for instance c4478f4b-94e2-461e-8981-20405cbd9cb8

Waiting for app to start...

name:              spring-music
requested state:   started
routes:            spring-music-proud-fossa.15.164.20.58.xip.io
last uploaded:     Wed 31 Jul 01:56:08 UTC 2019
stack:             cflinuxfs3
buildpacks:        https://github.com/PaaS-TA/SAAS-BUILDPACK-MASTER

type:            web
instances:       1/1
memory usage:    1024M
start command:   JAVA_OPTS="-agentpath:$PWD/.java-buildpack/open_jdk_jre/bin/jvmkill-1.16.0_RELEASE=printHeapHistogram=1 -Djava.io.tmpdir=$TMPDIR -javaagent:$PWD/.java-buildpack/pinpoint_agent/pinpoint-bootstrap-1.8.4.jar
                 -Dpinpoint.agentId=spring-music -Dpinpoint.applicationName=spring-music -Djava.ext.dirs=$PWD/.java-buildpack/container_security_provider:$PWD/.java-buildpack/open_jdk_jre/lib/ext
                 -Djava.security.properties=$PWD/.java-buildpack/java_security/java.security $JAVA_OPTS" && CALCULATED_MEMORY=$($PWD/.java-buildpack/open_jdk_jre/bin/java-buildpack-memory-calculator-3.13.0_RELEASE -totMemory=$MEMORY_LIMIT
                 -loadedClasses=24435 -poolType=metaspace -stackThreads=250 -vmOptions="$JAVA_OPTS") && echo JVM Memory Configuration: $CALCULATED_MEMORY && JAVA_OPTS="$JAVA_OPTS $CALCULATED_MEMORY" && MALLOC_ARENA_MAX=2 SERVER_PORT=$PORT eval exec
                 $PWD/.java-buildpack/open_jdk_jre/bin/java $JAVA_OPTS -cp $PWD/. org.springframework.boot.loader.JarLauncher
     state     since                  cpu    memory         disk           details
#0   running   2019-07-31T01:57:00Z   0.8%   208.5M of 1G   176.5M of 1G   
```


### <div id='22'> 2.2. Sample Web App에 서비스 확인
-------------------------------------------------

Sample App(spring-music) cf push 정상적으로 완료 되었으면 Pinpoint Collector 서버 수집을 된다.
 
```
$ cf apps
```
```
Getting apps in org rex-org / space rex-space as admin...
OK

name           requested state   instances   memory   disk   urls
rex-app        started           1/1         1G       1G     rex-app.15.164.20.58.xip.io
spring-music   started           1/1         1G       1G     spring-music-proud-fossa.15.164.20.58.xip.io
```

Sample App(spring-music) urls 확인하고 IE/Chrome 브라우져에서 해당 URL로 정상적으로 동작 되지는 확인한다.
Pinpoint Web urls 확인하고 IE/Chrome 브라우져 실행하여 Application 목록에 해당 app 등록 되었는지 확인한다.
Pinpoint Web Inspect 화면을 통해 해당 성능 지표들이 수집되어 표시 되는지 확인한다.

![Sample App 브라우저 실행][pinpoint_image_02]

![Sample App 브라우저 실행][pinpoint_image_03]

![Sample App 브라우저 실행][pinpoint_image_04]


* 위 과정들이 정상적으로 실행되지 않는 경우 로그를 확인한다.
```
$ cf logs spring-music --recent
```
```
   2019-07-31T04:05:08.53+0000 [RTR/1] OUT spring-music-proud-fossa.15.164.20.58.xip.io - [2019-07-31T04:05:08.528+0000] "GET /albums HTTP/1.1" 200 0 4669 "http://spring-music-proud-fossa.15.164.20.58.xip.io/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36" "10.0.0.231:55652" "10.0.41.242:61073" x_forwarded_for:"61.40.138.66, 10.0.0.231" x_forwarded_proto:"http" vcap_request_id:"f5da8972-f530-4bc8-7409-4db38e6befb7" response_time:0.006060672 app_id:"bf60a3b5-c937-4d9f-ae97-3f7a7ef81d24" app_index:"0" x_b3_traceid:"1218ff63be48b0e5" x_b3_spanid:"1218ff63be48b0e5" x_b3_parentspanid:"-" b3:"1218ff63be48b0e5-1218ff63be48b0e5"
   2019-07-31T04:05:08.53+0000 [RTR/1] OUT 
se_time:0.004120268 app_id:"bf60a3b5-c937-4d9f-ae97-3f7a7ef81d24" app_index:"0" x_b3_traceid:"3b997ad67c040e09" x_b3_spanid:"3b997ad67c040e09" x_b3_parentspanid:"-" b3:"3b997ad67c040e09-3b997ad67c040e09"
   2019-07-31T04:05:08.83+0000 [RTR/0] OUT 
   2019-07-31T04:05:08.83+0000 [RTR/1] OUT spring-music-proud-fossa.15.164.20.58.xip.io - [2019-07-31T04:05:08.830+0000] "GET / HTTP/1.1" 304 0 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36" "10.0.0.231:55670" "10.0.41.242:61073" x_forwarded_for:"61.40.138.66, 10.0.0.231" x_forwarded_proto:"http" vcap_request_id:"8b7cfd48-5d14-4aaf-649c-93c2fc0d369a" response_time:0.004944938 app_id:"bf60a3b5-c937-4d9f-ae97-3f7a7ef81d24" app_index:"0" x_b3_traceid:"b2c53e3368320700" x_b3_spanid:"b2c53e3368320700" x_b3_parentspanid:"-" b3:"b2c53e3368320700-b2c53e3368320700"
   2019-07-31T04:05:08.83+0000 [RTR/1] OUT 
   2019-07-31T04:05:09.07+0000 [RTR/0] OUT spring-music-proud-fossa.15.164.20.58.xip.io - [2019-07-31T04:05:09.073+0000] "GET /appinfo HTTP/1.1" 200 0 48 "http://spring-music-proud-fossa.15.164.20.58.xip.io/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36" "10.0.0.231:55778" "10.0.41.242:61073" x_forwarded_for:"61.40.138.66, 10.0.0.231" x_forwarded_proto:"http" vcap_request_id:"7a92f28a-0811-4ae5-726a-d1a4d89bd1c4" response_time:0.004305851 app_id:"bf60a3b5-c937-4d9f-ae97-3f7a7ef81d24" app_index:"0" x_b3_traceid:"f3f582aaf770072c" x_b3_spanid:"f3f582aaf770072c" x_b3_parentspanid:"-" b3:"f3f582aaf770072c-f3f582aaf770072c"
   2019-07-31T04:05:09.07+0000 [RTR/0] OUT 
   2019-07-31T04:05:09.08+0000 [RTR/1] OUT spring-music-proud-fossa.15.164.20.58.xip.io - [2019-07-31T04:05:09.083+0000] "GET /albums HTTP/1.1" 200 0 4669 "http://spring-music-proud-fossa.15.164.20.58.xip.io/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36" "10.0.0.231:55676" "10.0.41.242:61073" x_forwarded_for:"61.40.138.66, 10.0.0.231" x_forwarded_proto:"http" vcap_request_id:"6c368d39-d025-43b5-51be-2405ef3bf3b0" response_time:0.005162675 app_id:"bf60a3b5-c937-4d9f-ae97-3f7a7ef81d24" app_index:"0" x_b3_traceid:"417447dcbe2bcc74" x_b3_spanid:"417447dcbe2bcc74" x_b3_parentspanid:"-" b3:"417447dcbe2bcc74-417447dcbe2bcc74"
   2019-07-31T04:05:09.08+0000 [RTR/1] OUT 


```



[pinpoint_image_01]:/images/pinpoint_architecture.png
[pinpoint_image_02]:/images/sample_app_load.png
[pinpoint_image_03]:/images/pinpoint_server_1.png
[pinpoint_image_04]:/images/pinpoint_server_2.png
