import 'nodes/*.pp'

#monit
import 'monit/classes/*.pp'

node default {
  notify{
    "error! not match your node , this is default node":
  }
}
