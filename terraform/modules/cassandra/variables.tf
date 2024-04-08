resource "aws_keyspaces_keyspace" "this" {
  name = var.keyspace_name
}

variable "cassandra_tables" {
  default = {
    main = {
      schema_definitions = [
        {
          partition_key = "id"
          columns = [
            { name = "Column 1", type = "ASCII" },
            { name = "Column 2", type = "ASCII" },
            { name = "Column 3", type = "ASCII" },
            { name = "Column 4", type = "ASCII" },
            { name = "Column 5", type = "ASCII" },
          ]
        }
      ]
    }
  }
}
