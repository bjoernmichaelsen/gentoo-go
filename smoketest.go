//usr/bin/go run $0 $@; exit $?
package main

import "fmt"
import "os/exec"
import "runtime"

func main() {
    portage, _ := exec.Command("emerge", "-pv", "sys-apps/portage", "dev-lang/go").Output()
    fmt.Printf("%s\n", runtime.Version())
    fmt.Printf("%s", portage)
}
