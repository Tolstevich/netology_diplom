resource "yandex_compute_snapshot_schedule" "snapshot" {
    name = "snapshot"

    schedule_policy {
        expression   = "0 6 * * *"
    }
    retention_period = "168h"

    snapshot_spec {
        description = "daily snapshot"
    }

    disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web_01.boot_disk[0].disk_id,
    yandex_compute_instance.web_02.boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
    ]
}