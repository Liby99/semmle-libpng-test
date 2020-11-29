#define NULL 0

struct png_struct {};
struct png_info_struct {};

struct png_struct *png_create_write_struct() {
  return 0;
}

struct png_info_struct *png_create_info_struct(struct png_struct *png_ptr) {
  return 0;
}

void png_destroy_write_struct(struct png_struct **png_ptr, struct png_info_struct **info_ptr) {
  return;
}

int test() {
  struct png_struct *png_ptr;
  struct png_info_struct *info_ptr;

  png_ptr = png_create_write_struct();
  if (png_ptr == NULL) return 2;
  info_ptr = png_create_info_struct(png_ptr);
  if (info_ptr == NULL) {
    png_destroy_write_struct(&png_ptr, NULL);
    return 2;
  }

  png_destroy_write_struct(&png_ptr, NULL);
  return 0;
}

int main() {
  test();
}