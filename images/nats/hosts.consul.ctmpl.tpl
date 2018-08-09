{{range service "$zone.nats"}}
{{.Address}} $zone.{{.Name}} $zone.{{.Name}}.service.consul{{end}}  
