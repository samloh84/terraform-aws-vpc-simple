
data "external" "local_ip" {
  program = [
    "python",
    "${path.module}/checkip.py"]
}
