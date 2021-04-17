// go run src/go/reset/reset.go

package main

import (
	"github.com/initc3/HoneyBadgerSwap/src/go/utils"
	"os"
)

const (
	network  = "testnet"
	KEYSTORE = os.Getenv("POA_KEYSTORE")
)

func main() {
	conn := utils.GetEthClient(utils.TestnetWsEndpoint)
	owner := utils.GetAccount(KEYSTORE)

	utils.ResetPrice(network, conn, owner, utils.EthAddr, utils.HbSwapTokenAddr[network])
	utils.ResetPrice(network, conn, owner, utils.EthAddr, utils.DAIAddr[network])
	utils.ResetPrice(network, conn, owner, utils.DAIAddr[network], utils.HbSwapTokenAddr[network])
}
