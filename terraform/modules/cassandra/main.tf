variable "keyspace_name" {
  default = ""
}

resource "aws_keyspaces_table" "this" {
  for_each = var.cassandra_tables

  keyspace_name = aws_keyspaces_keyspace.this.name
  table_name    = each.value["name"]

  schema_definition {
    column {
      name = "Message"
      type = "ASCII"
    }

    partition_key {
      name = "Message"
    }
  }
}