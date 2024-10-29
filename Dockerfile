FROM amazon/aws-cli

# 필요한 패키지 설치
RUN yum update -y && \
    yum install -y yum-utils shadow-utils wget tar gzip

# Terraform 설치
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    yum install -y terraform

# kubectl 설치
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Amazon Corretto JDK 17 설치
RUN yum install -y java-17-amazon-corretto-devel

# Gradle 설치
RUN wget https://services.gradle.org/distributions/gradle-7.6-bin.zip && \
    unzip gradle-7.6-bin.zip -d /opt && \
    ln -s /opt/gradle-7.6 /opt/gradle && \
    rm gradle-7.6-bin.zip

# 환경 변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}

# 작업 디렉토리 생성
WORKDIR /app

# GitHub Actions에서 빌드된 JAR 파일만 복사
COPY build/libs/AIWA-MCP-Backend-TerraformService-0.0.1-SNAPSHOT.jar /app/AIWA-MCP-Backend-TerraformService-0.0.1-SNAPSHOT.jar

# 기본 셸을 bash로 설정
SHELL ["/bin/bash", "-c"]

# 컨테이너 시작 시 실행할 명령어
CMD ["/bin/bash"]