import { Box, Card, Container, Flex, Heading } from "theme-ui";

import { Trove } from "../components/Trove/Trove";
import { Stability } from "../components/Stability/Stability";
import { SystemStats } from "../components/SystemStats";
import { PriceManager } from "../components/PriceManager";
import { Staking } from "../components/Staking/Staking";

export const Dashboard: React.FC = () => (
  <>
    <Container padding='10px'>
      <Card {...{ variant: 'welcome' }}>
        <Flex sx={{ alignItems: 'center', }} >

          <Box p={2}  >
            <img src="/chest.png" alt="chest" />
          </Box>
          <Box p={2}  >
            <h1>Borrow LUSD against ETH at 0% interest.</h1>
            <h2>
              Powered by <a href="https://liquity.org" title="Liquity" target="_blank">Liquity protocol</a>
            </h2>
            <div className="network">This liquity front-end has 99.5% KickBack Rate. High <a title="LQTY" href="https://docs.liquity.org/faq/lqty-distribution-and-rewards">LQTY rewards</a>.</div>
            <div className="network">Current cost of opening a Trove around 120$ due to gas fees.</div>
          </Box>
        </Flex>
      </Card>

    </Container>
    <Container variant="columns" marginBottom={100} padding='10px'>
      <Container variant="left">
        <Trove />
        <Stability />
        <Staking />
      </Container>

      <Container variant="right">
        <Card>
          <Heading>How to use Liquity to maximize profits?</Heading>
          <Box p={2}>
            <ul>
              <li>
                Open a Trove and get LUSD
              </li>
              <li>
                Put LUSD into Stability Pool and earn LQTY & ETH
              </li>
              <li>
                Use ETH to increase collateral and deposit LQTY into Staking
              </li>
              <li>
                Earn ETH & LUSD via Staking. Use ETH to increase collateral  and LUSD to decrease debt, hence improving you collaterizition ratio.
              </li>

            </ul>
          </Box>
        </Card>
        <SystemStats />
        <PriceManager />
      </Container>
    </Container>
  </>
);
