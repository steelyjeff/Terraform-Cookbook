data "archive_file" "backup" {
    type = "zip"
    source_file = "${path.module}/mytextfile.txt"
    output_path = "${path.module}/archives/backup.zip"
}