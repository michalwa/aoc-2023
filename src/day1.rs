use std::io::BufRead;

const DIGIT_STRINGS: [&str; 9] = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
];

pub fn main(input: impl BufRead) {
    let enumerated_digit_strings = DIGIT_STRINGS.iter().zip(1..);
    let result = input
        .lines()
        .map(|line| {
            let line = line.unwrap();

            let left = enumerated_digit_strings
                .clone()
                .filter_map(|(s, i)| line.find(s).map(|j| (j, i)))
                .chain(
                    line.find(|c: char| c.is_ascii_digit())
                        .map(|j| (j, line.as_bytes()[j] - b'0')),
                )
                .min_by_key(|&(j, _)| j)
                .unwrap()
                .1 as u32;

            let right = enumerated_digit_strings
                .clone()
                .filter_map(|(s, i)| line.rfind(s).map(|j| (j, i)))
                .chain(
                    line.rfind(|c: char| c.is_ascii_digit())
                        .map(|j| (j, line.as_bytes()[j] - b'0')),
                )
                .max_by_key(|&(j, _)| j)
                .unwrap()
                .1 as u32;

            left * 10 + right
        })
        .sum::<u32>();

    println!("{result}");
}
