// SPDX-License-Identifier: MIT

%lang starknet

// StarkWare dependencies

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le
from starkware.starknet.common.syscalls import get_caller_address
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.uint256 import Uint256

// Local dependencies

from src.utils.interfaces.IERC20 import IERC20
from src.utils.SafeERC20 import SafeERC20

// Declaring structs

struct Courses {
    courseOwner: felt,
    totalStaked: felt,
    stakedToken: felt,
}

struct Tasks{
    studentStatus : felt,
    studentReward : felt,
    rewardAmount : felt,
    challengeId : felt,
    storedAnswer : felt,
}

// Declaring storage variables

@storage_var
func owner() -> (owner_address: felt) {
}

@storage_var
func whitelistedTokens() -> (res: felt) {
}

@storage_var
func course_owner(course_id: felt) -> (res: felt) {
}

@storage_var
func total_staked(course_id: felt) -> (res: felt) {
}

@storage_var
func staked_token(course_id: felt) -> (res: felt) {
}



// Declaring getters

@storage_var
func accountBalances(address: felt, tokenAddress: felt) -> (accountBalance: felt) {
}

@storage_var
func courses(course_id: felt) -> (res: Courses) {
}


// Events

@event
func CourseAdded(courseOwner : felt, totalStaked : felt, stakedTokenAddress : felt, courseId : felt){
}

//Constructor

@constructor
func constructor{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(owner_address: felt) {
    owner.write(value=owner_address);
    return ();
}

// External functions

@external
func querryCourse{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    course_id: felt
) -> (course_stats: Courses) {

alloc_locals;

let (caller_address) = get_caller_address();
let (contract_address) = get_contract_address();
let (owner) = course_owner.read(course_id);
let (total) = total_staked.read(course_id);
let (address) = staked_token.read(course_id);


let course_stats = Courses(courseOwner = owner, totalStaked = total, stakedToken = address);

return(course_stats = course_stats);

}

@external
func addCourse{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    course_id: felt, totalStaked: felt, stakedTokenAddress: felt
) {

alloc_locals;

let (caller_address) = get_caller_address();
let (contract_address) = get_contract_address();

course_owner.write(course_id, caller_address);
total_staked.write(course_id, totalStaked);
staked_token.write(course_id, stakedTokenAddress);

CourseAdded.emit(caller_address, totalStaked, stakedTokenAddress, course_id);

return();
    
}

@view
func viewCourse{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(courseId: felt) -> (
    course_stats: Courses
) {
    
    let (show_course) = querryCourse(courseId);
    return (show_course,);
}

