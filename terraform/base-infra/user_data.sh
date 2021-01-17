#!/bin/bash
echo ECS_CLUSTER='ecs-cluster' >> /etc/ecs/ecs.config
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cat <<EOF >/home/ec2-user/docker-compose.yml
node-exporter:
   image: prom/node-exporter
   ports:
      - '9100:9100'
cadvisor-exporter:
   image: google/cadvisor
   ports:
      - "9200:8000"
   privileged: true
   volumes:
      - /:/rootfs:ro
      - /cgroup:/cgroup:ro
      - /var/run:/var/run:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
      - /cgroup:/sys/fs/cgroup:ro
EOF
chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml
/usr/local/bin/docker-compose -f /home/ec2-user/docker-compose.yml up -d