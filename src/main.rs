use std::{
    fs::File,
    io::{BufRead, BufReader},
};

macro_rules! day_runner {
    ($runner:ident { $($day:ident),* $(,)? }) => {
        $( mod $day; )*

        fn $runner(day_name: &str, input: impl BufRead) {
            match day_name {
                $( stringify!($day) => $day::main(input), )*
                _ => panic!("no such day"),
            }
        }
    };
}

day_runner! {
    run_day { day1 }
}

fn main() {
    let mut args = std::env::args();
    args.next().unwrap();

    let day_name = args.next().unwrap();
    let input_filename = args.next().unwrap();
    let input_reader = BufReader::new(File::open(input_filename).unwrap());

    run_day(&day_name, input_reader);
}
