# ベースイメージの指定
FROM amazonlinux:2

LABEL maintainer="<infratop>" \
  description="Amazon Linux 2 with some development environments"

# 必要なパッケージをインストール
RUN yum update -y && \
  yum install -y \
  mariadb \
  mariadb-devel \
  mariadb-client \
  sudo \
  gcc \
  gcc-c++ \
  make \
  autoconf \
  bzip2 \
  curl \
  git \
  libpng-devel \
  libjpeg-devel \
  libwebp-devel \
  freetype-devel \
  gmp-devel \
  sqlite-devel \
  openssl-devel \
  zip \
  unzip \
  tar \
  libxml2-devel \
  libcurl-devel \
  oniguruma \
  oniguruma-devel \
  util-linux && \
  yum clean all

# Node.js のインストール
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - && \
  yum install -y nodejs && \
  yum clean all

# Yarn のインストール
RUN npm install --global yarn

# Ruby 3.1.2 のインストール
RUN curl -sSL https://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.2.tar.gz -o ruby.tar.gz && \
  tar -xzf ruby.tar.gz && \
  cd ruby-3.1.2 && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -rf ruby-3.1.2 ruby.tar.gz

# Rails 6.1.4 のインストール
RUN gem install rails -v 6.1.4

# PHP 8.2 のインストール
RUN yum update -y && \
  yum install -y amazon-linux-extras && \
  amazon-linux-extras enable php8.2 && \
  yum clean metadata && \
  yum install -y php-cli php-pdo php-mbstring php-mysqlnd php-json php-gd php-openssl php-curl php-xml php-intl && \
  yum clean all

# Composerのインストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
  php -r "unlink('composer-setup.php');"

# ec2-user を作成
RUN useradd -ms /bin/bash ec2-user && \
  echo "ec2-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# rootパスワードの設定
RUN echo "root:root" | chpasswd

# ec-user、作業ディレクトリの作成と権限の設定
RUN mkdir -p /home/ec2-user/environment && \
  chown -R ec2-user:ec2-user /home/ec2-user && \
  echo "ec2-user:password" | chpasswd

# ターミナルプロンプトのカスタマイズ
COPY prompt.sh /root/prompt.sh
RUN chmod 755 /root/prompt.sh
RUN echo 'source ~/prompt.sh' >> /root/.bashrc
RUN echo 'source ~/prompt.sh' >> /root/.bash_profile

COPY prompt.sh /home/ec2-user/prompt.sh
RUN sudo chmod 755 /home/ec2-user/prompt.sh
RUN echo 'source ~/prompt.sh' >> /home/ec2-user/.bashrc
RUN echo 'source ~/prompt.sh' >> /home/ec2-user/.bash_profile


# ec2-user で作業ディレクトリを使用
USER ec2-user
WORKDIR /home/ec2-user/environment

# テストコードをコピー
RUN mkdir docs
COPY docs/ docs/
COPY README.md README.md

# デフォルトコマンド
CMD ["bash"]




