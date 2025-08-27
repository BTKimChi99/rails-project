FROM ruby:3.2

# --- Cài thêm dependency cần cho image_processing, mini_magick hoặc ruby-vips ---
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  default-mysql-client \
  libvips libvips-dev \
  imagemagick libmagickwand-dev \
  libffi-dev libjpeg-dev libpng-dev

# --- Thiết lập thư mục làm việc ---
WORKDIR /app

# --- Copy và cài gem ---
COPY Gemfile Gemfile.lock ./
RUN bundle install

# --- Copy toàn bộ code ---
COPY . .

EXPOSE 3000

# --- Lệnh khởi động server ---
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]
