import 'nodes/*.pp'

node default {
  notify{
    "error! not match your node , this is default node":
  }
}
