// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract AcornTest {
    struct Souls {
        string AccountName;
        uint256 ACorn_tokens;
        uint256 ACorn_earned;
        uint256 ACorn_used;
        uint256 Total_hours;
    }
    Souls[] public souls;

    struct Skills {
        string name;
        string[] souls_in_field;
        uint256[] souls_time;
    }
    Skills[] public skills;

    bool public test = false;

    enum lesson_performance {
        fair,
        good,
        excellent
    }
    lesson_performance public constant fair_performance =
        lesson_performance.fair;
    lesson_performance public constant good_performance =
        lesson_performance.good;
    lesson_performance public constant excellent_performance =
        lesson_performance.excellent;

    enum level {
        exploration,
        beginner,
        intermediate,
        advanced,
        master
    }
    level public constant level_exploration = level.exploration;
    level public constant level_beginner = level.beginner;
    level public constant level_intermediate = level.intermediate;
    level public constant level_advanced = level.advanced;
    level public constant level_master = level.master;

    constructor() {}

    function add_new_souls(string memory account_name) public {
        Souls memory soul = Souls(account_name, 0, 0, 0, 0);
        souls.push(soul);
    }

    function add_new_skills(string memory skill_name) public {
        uint256[] memory souls_time = new uint256[](0);
        string[] memory souls_array = new string[](0);
        Skills memory new_skill = Skills(skill_name, souls_array, souls_time);
        skills.push(new_skill);
    }

    function join_skill(
        string memory skill_join,
        string memory account
    ) public {
        for (uint256 i = 0; i < skills.length; i++) {
            if (
                keccak256(bytes(skills[i].name)) == keccak256(bytes(skill_join))
            ) {
                skills[i].souls_in_field.push(account);
                skills[i].souls_time.push(0);
                test = true;
            }
        }
    }

    function retrieve() public view returns (string memory) {
        return skills[0].souls_in_field[0];
    }

    function finish_skills_lesson() public {}

    function finish_skills_level() public {}
}
