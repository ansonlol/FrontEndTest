// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "@openzeppelin/contracts/utils/Strings.sol";

contract AcornTest {
    //imports
    using Strings for uint256;

    //1 souls init, and check functions
    struct Souls {
        uint256 ACorn_tokens;
        uint256 ACorn_earned;
        uint256 ACorn_used;
        uint256 Total_hours;
        //skill referring the the entire list of skill started
        uint256[] skillIndices;
        //list of skills the suols started
        string[] skillName;
        string[] buy_history;
    }
    //lists of accounts
    mapping(string accountname => Souls) souls;

    function check_accounts(
        string memory account_name
    )
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256[] memory,
            string[] memory,
            string[] memory
        )
    {
        Souls memory temp = souls[account_name];
        return (
            temp.ACorn_tokens,
            temp.ACorn_earned,
            temp.ACorn_used,
            temp.Total_hours,
            temp.skillIndices,
            temp.skillName,
            temp.buy_history
        );
    }

    //2. skills init and check function
    struct Skills {
        string name;
        string level;
        string[] performance;
        uint256 hour_spent;
    }
    Skills[] public skills;

    function check_skills(
        string memory account_name,
        string memory skill_name
    ) public view returns (string memory, string[] memory, uint256) {
        uint256 skillIndex = account_name_and_skill_to_index(
            account_name,
            skill_name
        );
        return (
            skills[skillIndex].level,
            skills[skillIndex].performance,
            skills[skillIndex].hour_spent
        );
    }

    bool public test = false;

    //create new user account
    function add_new_souls(string memory account_name) public {
        Souls memory soul = Souls(
            0,
            0,
            0,
            0,
            new uint256[](0),
            new string[](0),
            new string[](0)
        );
        souls[account_name] = (soul);
    }

    // each souls can join a new skill
    function join_skill(
        string memory account_name,
        string memory skill_name
    ) public {
        Skills memory skill = Skills(
            skill_name,
            "Exploration",
            new string[](0),
            0
        );
        uint256 skillIndex = skills.length;
        skills.push(skill);
        souls[account_name].skillIndices.push(skillIndex);
        souls[account_name].skillName.push(skill_name);
    }

    //create new skills for souls to learn

    //function retrieve() public view returns(string memory) {
    //  return skills[0].souls_in_field[0];
    //}

    //update acorn earn, total hour, acorn token,performance, hourspent
    function finish_skills_lesson(
        string memory skill_name,
        string memory account_name,
        string memory performance,
        uint256 time
    ) public {
        uint256 tokens_earn_during_lesson = performance_to_token(performance);

        //update profile thing
        souls[account_name].ACorn_tokens += tokens_earn_during_lesson;
        souls[account_name].ACorn_earned += tokens_earn_during_lesson;
        souls[account_name].Total_hours += time;

        //update skill thing

        uint256 skill_index = account_name_and_skill_to_index(
            account_name,
            skill_name
        );
        skills[skill_index].performance.push(performance);
        skills[skill_index].hour_spent += time;
    }

    function finish_skills_level(
        string memory account_name,
        string memory skill_name,
        string memory finish_level
    ) public {
        uint256 tokens_earned_finish_level;
        string memory next_level;
        (tokens_earned_finish_level, next_level) = level_to_tokens(
            finish_level
        );
        //update profile
        souls[account_name].ACorn_tokens += tokens_earned_finish_level;
        souls[account_name].ACorn_earned += tokens_earned_finish_level;
        //update skill
        uint256 skill_index = account_name_and_skill_to_index(
            account_name,
            skill_name
        );
        skills[skill_index].level = next_level;
    }

    function buy_time_to_play(
        string memory account_name,
        uint256 time_minute
    ) public {
        uint256 tokens_paid_to_time = time_play_to_tokens(time_minute);
        //update profile
        souls[account_name].ACorn_tokens -= tokens_paid_to_time;
        souls[account_name].ACorn_used += tokens_paid_to_time;
        souls[account_name].buy_history.push(
            string(
                abi.encodePacked(
                    "Buy time for ",
                    time_minute.toString(),
                    " minutes. Tokens Used: ",
                    tokens_paid_to_time.toString()
                )
            )
        );
    }

    function compareStrings(
        string memory a,
        string memory b
    ) public pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function performance_to_token(
        string memory performance
    ) public pure returns (uint256) {
        uint256 tokens_earn_during_lesson;
        if (compareStrings(performance, "Fair")) {
            tokens_earn_during_lesson = 10;
        } else if (compareStrings(performance, "Good")) {
            tokens_earn_during_lesson = 20;
        } else if (compareStrings(performance, "Excellent")) {
            tokens_earn_during_lesson = 30;
        }
        return tokens_earn_during_lesson;
    }

    function level_to_tokens(
        string memory finish_level
    ) public pure returns (uint256, string memory) {
        uint256 tokens_earn;
        string memory next_level;
        if (compareStrings(finish_level, "Exploration")) {
            tokens_earn = 100;
            next_level = "Beginner";
        } else if (compareStrings(finish_level, "Beginner")) {
            tokens_earn = 200;
            next_level = "Advanced";
        } else if (compareStrings(finish_level, "Advanced")) {
            tokens_earn = 300;
            next_level = "Master";
        }
        return (tokens_earn, next_level);
    }

    function time_play_to_tokens(
        uint256 time_minutes
    ) public pure returns (uint256) {
        uint tokens_pay;
        tokens_pay = time_minutes * 2;
        return tokens_pay;
    }

    function account_name_and_skill_to_index(
        string memory account_name,
        string memory skill_name
    ) public view returns (uint256) {
        for (uint256 i = 0; i < souls[account_name].skillName.length; i++) {
            if (compareStrings(souls[account_name].skillName[i], skill_name)) {
                uint256 skill_index = souls[account_name].skillIndices[i];
                return skill_index;
            }
        }
        return type(uint256).max;
    }
}
